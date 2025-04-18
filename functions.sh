#!/bin/bash
# v.2025-04-17.011
# by blbMS
# -------------------------------------------------------------------------
colors() {
    Gray='\x1B[0;30m'
    Red='\x1B[0;31m'
    Green='\x1B[0;32m'
    Yellow='\x1B[0;33m'
    Blue='\x1B[0;34m'
    Magenta='\x1B[0;35m'
    Cyan='\x1B[0;36m'
    White='\x1B[0;37m'
    iGray='\x1B[1;30m'
    iRed='\x1B[1;31m'
    iGreen='\x1B[1;32m'
    iYellow='\x1B[1;33m'
    iBlue='\x1B[1;34m'
    iMagenta='\x1B[1;35m'
    iCyan='\x1B[1;36m'
    iWhite='\x1B[1;37m'
    xBlue='\x1B[1;94m'
    C_Off='\x1B[0m'
}
# -------------------------------------------------------------------------
web-json() {
    web_dir=$(jq -r '.web_dir' "$mydata_json" | sed "s|^~|$HOME|")
    cd "$web_dir" || exit 1
    git add data.json
    git add index.html
    git add favicon.ico
    git commit -m "$(date '+%H:%M:%S %d.%m.%Y')"
    git pull --rebase origin main
    git push origin main
    cd "$home_dir"
}
# -------------------------------------------------------------------------
api_pc() {
    perl -e '
    use strict;
    use warnings;
    use IO::Socket::INET;

    my ($command, $address, $port) = @ARGV;

    my $sock = new IO::Socket::INET (
        PeerAddr => $address,
        PeerPort => $port,
        Proto    => "tcp",
        ReuseAddr => 1,
        Timeout   => 2,
    );

    if ($sock) {
        print $sock $command;
        my $res = "";
        while (<$sock>) { $res .= $_; }
        close($sock);
        print("$res\n");
    } else {
        print("No Connection\n");
    }
    ' "$@"
}
# -------------------------------------------------------------------------
read_api() {
    echo "### NOT ACTIVE DEVICES $(date +'%d.%m.%Y  %T')" > "$noact_tmp"
    > "$dev_on_list"
    max_length=0
    all=0
    off=0
    on=0
    while read line; do
        if ! [[ $line =~ ^### ]]; then
            all=$((all+1))
            if [[ $line =~ ^# ]]; then
                off=$((off+1))
                if [[ "$not_on_list" -eq "1" ]]; then
                    ip=$(echo "$line" | awk '{print $1}')
                    name=$(echo "$line" | awk '{print $2}')
                    echo -e "${ip} ${name}" >> "$dev_on_list"
                    length=$(echo -n "$name" | wc -c)
                    if (( length > max_length )); then
                        max_length=$length
                    fi
                fi
            else
                on=$((on+1))
                ip=$(echo "$line" | awk '{print $1}')
                name=$(echo "$line" | awk '{print $2}')
                echo -e "${ip} ${name}" >> "$dev_on_list"
                length=$(echo -n "$name" | wc -c)
                if (( length > max_length )); then
                    max_length=$length
                fi
            fi
        fi
    done < "$device_list"
    if [ "$set_colors" = "1" ]; then
        echo -ne "\e[3;1H\e[K${Yellow}Start time: $start_time_display  "
    else
        echo -ne "\e[3;1H\e[KStart time: $start_time_display  "
    fi
    if [ "$not_on_list" = "1" ]; then
        all_dev=$all
    else
        all_dev=$on
    fi
    BUILD="["
    all=0
    act=0
    inact=0
    mhsall=0.0
    while read -r line; do
        ((all++))
        ip=$(echo "$line" | awk '{print $1}')
        device_org=$(echo "$line" | awk '{print $2}')
        length=$(echo -n "$device_org" | wc -c)
        spaces=$(( max_length - length ))
        device=$(printf "%s%*s" "$device_org" $spaces "" | tr ' ' '_')
        if [ "$set_colors" = "1" ]; then
            echo -ne "\e[3;28H\e[K${White}Device: ${Red}($all/$all_dev) ${Blue}$ip ${Green}$device_org\e[0m"
        else
            echo -ne "\e[3;28H\e[KDevice: ($all/$all_dev) $ip $device_org"
        fi
        if [[ $line =~ ^# ]]; then
            ip="${ip#\#}"
            iip=$(echo "$ip" | awk -F. '{printf "%03d.%03d.%03d.%03d", $1, $2, $3, $4}')
            BUILD="$BUILD{\"PHONE\":\"$device\",\"HOST\":\"$iip\",\"POOL\":\"NOT-ON-LIST\",\"MHS\":\"_____\"},"
        else
            RESPONSE=$(printf "{\"PHONE\":\"$device\",\"HOST\":\"$ip\",\""; api_pc "summary" $ip $port | tr -d '\0' | sed -r \
            's/=/":"/g; s/;/\",\"/g' | sed 's/|/",/g')$(printf "\""; api_pc "pool" $ip $port | tr -d \
            '\0' | sed -r 's/=/":"/g' | sed -r 's/;/\",\"/g' | sed 's/|/"},/g')
            iip=$(echo "$ip" | awk -F. '{printf "%03d.%03d.%03d.%03d", $1, $2, $3, $4}')
            if [[ "$RESPONSE" == *"No Connect"* ]]; then
                inact=$((inact+1))
                if [[ "$not_on" -eq "1" ]]; then
                    BUILD="$BUILD{\"PHONE\":\"$device\",\"HOST\":\"$iip\",\"POOL\":\"OFF-LINE\",\"MHS\":\"0.000\"},"
                else
                    BUILD="$BUILD{\"PHONE\":\"$device\",\"HOST\":\"$iip\",\"POOL\":\"OFF-LINE___\",\"MHS\":\"0.000\"},"
                fi
                echo "$iip  $device" >> "$noact_tmp"
            else
                RESPONSE=$(echo "$RESPONSE" | jq -c '{PHONE,HOST,POOL,KHS}' 2>/dev/null)
                POOL=$(echo "$RESPONSE" | jq -r '.POOL')
                RESPONSE="$RESPONSE,"
                if grep -q '"KHS"' <<< "$RESPONSE"; then
                    KHS=$(echo "$RESPONSE" | grep -o '"KHS":"[0-9.]\+"' | cut -d '"' -f 4)
                    MHS=$(echo "scale=3; $KHS / 1000" | bc)
                    if (( $(echo "$MHS < 1000" | bc -l) )); then
                        MHS=$(printf "%.3f" $MHS)
                    fi
                    RESPONSE=$(echo "$RESPONSE" | sed "s/\"KHS\":\"$KHS\"/\"MHS\":\"$MHS\"/")
                fi
                length=$(echo -n "$POOL" | wc -c)
                if [[ "$not_on" -eq "1" ]]; then
                    pool_len=8
                else
                    pool_len=11
                fi
                if [[ "$length" -lt "$pool_len" ]]; then
                    spaces=$(( $pool_len - length ))
                    POOL11=$(printf "%s%*s" "$POOL" $spaces "" | tr ' ' '_')
                    RESPONSE=$(echo "$RESPONSE" | sed "s/\"POOL\":\"$POOL\"/\"POOL\":\"$POOL11\"/")
                fi
                RESPONSE=$(echo "$RESPONSE" | sed "s/\"HOST\":\"$ip\"/\"HOST\":\"$iip\"/")
                BUILD="$BUILD$RESPONSE"
                RESP=$(echo "$RESPONSE" | sed 's/,$//')
                act=$((act+1))
                mhs=$(echo "$RESP" | grep -o '"MHS":"[0-9.]\+"' | cut -d '"' -f 4)
                mhsall=$(bc <<< "scale=3; $mhsall + $mhs")
            fi
        fi
    done < "$dev_on_list"
    BUILD="${BUILD::-1}"
    JSON=$BUILD"]"
    echo -e "$JSON" > "$home_dir/check-all.tmp"
    jq . "$home_dir/check-all.tmp" > "$device_json"
    rm "$home_dir/dev_no_act.list"
    mv "$home_dir/dev_no_act.tmp" "$home_dir/dev_no_act.list"
    iteration=$(<"$home_dir/iteration.txt")
    iteration=$((iteration + 1))
    echo $iteration > "$home_dir/iteration.txt"
}
# -------------------------------------------------------------------------
making_summary() {
    cur_time=$(date +'%T')
    data=$(python3 -c "
import requests, json
url = 'https://api.minerstat.com/v2/coins'
response = requests.get(url, params={'list': 'VRSC'})
if response.status_code == 200:
    data = response.json()
    data[0]['reward'] *= 1e9  # Pretvori v večjo enoto
    print(json.dumps(data))
else:
    print('Error: no data', response.status_code)
    ")
    data2=$(echo "$data" | sed "s/'/\"/g")
    reward=$(python3 -c "import json, sys; data = json.load(sys.stdin); print(data[0]['reward'])" <<< "$data2")
    price=$(python3 -c "import json, sys; data = json.load(sys.stdin); print(data[0]['price'])" <<< "$data2")
    reward24MHs=$(echo "$reward * 1000000 * 24 * 0.000000001 " | bc)
    my_reward=$(echo "scale=10; $reward24MHs * $mhsall" | bc)
    my_reward_USDT=$(echo "scale=10; $my_reward * $price" | bc)
    my_reward_USDT2=$(printf "%.2f" $my_reward_USDT)
    my_reward2=$(printf "%.2f" $my_reward)
    jq -n --argjson all "$all" \
          --argjson mhs_all "$mhsall" \
          --argjson dev_active "$act" \
          --argjson dev_inactive "$inact" \
          --argjson dev_off "$off" \
          --argjson vrsc_day "$my_reward2" \
          --argjson usdt_day "$my_reward_USDT2" \
          --arg summ_time "$cur_time" \
          --argjson iteration "$iteration" \
          '{
            all_dev: $all,
            mhs_all: $mhs_all,
            dev_active: $dev_active,
            dev_inactive: $dev_inactive,
            dev_off: $dev_off,
            vrsc_day: $vrsc_day,
            usdt_day: $usdt_day,
            summ_time: $summ_time,
            iteration: $iteration
          }' > "$summary_json"
}
# -------------------------------------------------------------------------
summary() {
    echo -e "${iYellow}all devices     : $all"
    echo -e "${Green}active devices  : $act"
    echo -e "${Red}inactive devices: $inact"
    echo -e "${iRed}turned off      : $off"
    echo -e "${Magenta}iterations      : $iteration${C_Off}"
    echo
    tput cuu 6
    tput cuf 30
    echo -n -e "${iMagenta}all hash    : $mhsall MHs\n"
    tput cuf 30
    echo -n -e "${Blue}VRSC/day    : $my_reward2\n"
    tput cuf 30
    echo -n -e "${iBlue}USDT/day    : $my_reward_USDT2\n"
    tput cuf 30
    echo -n -e "${Yellow}time of data: $cur_time\n\n"
}
# -------------------------------------------------------------------------
summaryBW() {
    echo -e "all devices     : $all"
    echo -e "active devices  : $act"
    echo -e "inactive devices: $inact"
    echo -e "turned off      : $off"
    echo -e "iterations      : $iteration"
    echo
    tput cuu 6
    tput cuf 30
    echo -n -e "all hash    : $mhsall MHs\n"
    tput cuf 30
    echo -n -e "VRSC/day    : $my_reward2\n"
    tput cuf 30
    echo -n -e "USDT/day    : $my_reward_USDT2\n"
    tput cuf 30
    echo -n -e "time of data: $cur_time\n\n"
}
# -------------------------------------------------------------------------
sorted_devices() {
    rows=$(tput lines)
    cols=$(tput cols)
    if [ "$max_length" = "0" ]; then
        max_length=1
    fi
    if [ "$set_dev_line" = "0" ]; then
        set_dev_line=$((cols / max_length))
        set_dev_line=$((set_dev_line * max_length))
    fi
    rm -f $home_dir/pool.*
    unset pool_names pool_count all_pools
    declare -A pool_names pool_count
    declare -a all_pools
    unset sorted_pools all_sort_pools
    declare -a sorted_pools all_sort_pools
    while read -r line; do
        column3=$(echo $line | awk '{print $3}')
        if [[ -n "$column3" ]]; then
            ((pool_count["$column3"]++))
            if [[ -z "${pool_names[$column3]}" ]]; then
                pool_names[$column3]=1
                all_pools+=("$column3")
            fi
        fi
    done < "$device_last"
    sorted_pools=($(for p in "${all_pools[@]}"; do
        [[ "$p" == "OFF-LINE" || "$p" == "NOT-ON-LIST" ]] && continue
        echo "${pool_count[$p]} $p"
    done | sort -nr | awk '{print $2}'))
    [[ -n "${pool_count["OFF-LINE"]}" ]] && sorted_pools+=("OFF-LINE")
    [[ -n "${pool_count["NOT-ON-LIST"]}" ]] && sorted_pools+=("NOT-ON-LIST")
    max_pools=${#sorted_pools[@]}
    for ((i=1; i<=max_pools; i++)); do
        all_sort_pools[$i]="${sorted_pools[$((i-1))]}"
    done
    for ((i=1; i<=max_pools; i++)); do
        current_name="${all_sort_pools[$i]}"
        header="$current_name"
        while [[ "${header}" == *_ ]]; do
            header="${header%%_}"
        done
        echo "$header" > "$home_dir/pool.$i"
        device_count=0
        while read -r line; do
            column3=$(echo $line | awk '{print $3}')
            if [[ "$column3" == "$current_name" ]]; then
                ip=$(echo $line | awk '{print $2}')
                name=$(echo $line | awk '{print $1}')
                while [[ "${name}" == *_ ]]; do
                    name="${name%%_}"
                done
                echo "$ip   $name" >> "$home_dir/pool.$i"
                ((device_count++))
            fi
        done < "$device_last"
        echo "$device_count" >> "$home_dir/pool.$i"
    done
    sort_in_json="{\"SORT\":["
    for ((i=1; i<=max_pools; i++)); do
        input_file="$home_dir/pool.$i"
        if [[ -f "$input_file" ]]; then
            header=$(head -n 1 "$input_file")
            all_devs=$(tail -n 1 "$input_file")
            mapfile -t devices < <(head -n -1 "$input_file" | tail -n +2 | awk '{print $2}')
            json_devices=""
            if [[ "${#devices[@]}" -gt 0 ]]; then
                json_devices=$(printf '"%s",' "${devices[@]}")
                json_devices="${json_devices%,}" # Odstrani zadnjo vejico
            fi
            sort_in_json+="{\"$header\":{\"devices\":[$json_devices],\"nr-devs\":\"$all_devs\"}},"
        else
            echo "Datoteka $input_file ne obstaja."
        fi
    done
    sort_in_json="${sort_in_json%,}]}"
    echo "$sort_in_json" > "$sort_json"
}
# -------------------------------------------------------------------------
print_sorted_devices() {
    for ((i=$print_devices; i<=max_pools; i++)); do
        input_file="$home_dir/pool.$i"
        header=$(head -n 1 "$input_file")
        device_count=$(( $(tail -n +2 "$input_file" | wc -l) - 1 ))
        header="${header//_/} ($device_count)"
        N=$((set_dev_line - 5))
        count=0
        if [ "$set_colors" = "1" ]; then
            echo -e "\n${iWhite}$header\e[0m"
            device_names=$(tail -n +2 "$input_file" | awk '{print $2}' | sed 's/_*$//')
            colors=("${Blue}" "${Green}" "${iCyan}" "${iYellow}" "${iRed}")
            for name in $device_names; do
                color=${colors[$((count % ${#colors[@]}))]}
                echo -ne "$color$name\e[0m "
                ((count++))
                ((count % N == 0)) && echo
            done
            ((count % N != 0)) && echo
        else
            echo -e "\n$header"
            device_names=$(tail -n +2 "$input_file" | awk '{print $2}' | sed 's/_*$//')
            for name in $device_names; do
                echo -n "$name "
                ((count++))
                ((count % N == 0)) && echo
            done
            ((count % N != 0)) && echo
        fi
    done
}
# -------------------------------------------------------------------------
