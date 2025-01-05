#!/bin/bash
# v.2025-01-05
# by blbMS

script_dir=$(dirname "$(readlink -f "$0")")
data_json="$script_dir/mydata.json"
home_dir=$(jq -r '.home_dir' $data_json)
port=$(jq -r '.port' $data_json)
device_list=$(jq -r '.device_list' $data_json)
not_on_list=$(jq -r '.not_on_list' $data_json)
if [ "$not_on_list" == "1" ]; then
    not_on=1
else
    not_on=0
fi
dev_on_list="$home_dir/dev_on.list"
noact_list="$home_dir/dev_no_act.list"
noact_tmp="$home_dir/dev_no_act.tmp"
echo "NOT ACTIVE DEVICES $(date +'%d.%m.%Y  %T')" > "$noact_tmp"
max_length=0
all=0
off=0
on=0
rm -f "$dev_on_list"
touch "$dev_on_list"
while read line; do
    if ! [[ $line =~ ^### ]]; then
        all=$((all+1))
        if [[ $line =~ ^# ]]; then
            off=$((off+1))
            if [[ "$not_on" -eq "0" ]]; then
                ip=$(echo "$line" | awk '{print $1}')
                name=$(echo "$line" | awk '{print $2}')
                echo -e "${ip} ${name}" >> "$dev_on_list"
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
done < "$home_dir/$device_list"
BUILD="["
act=0
inact=0
mhsall=0.0
while read -r line; do
    ip=$(echo "$line" | awk '{print $1}')
    device_org=$(echo "$line" | awk '{print $2}')
    length=$(echo -n "$device_org" | wc -c)
    spaces=$(( max_length - length ))
    device=$(printf "%s%*s" "$device_org" $spaces "" | tr ' ' '_')
    if [[ $line =~ ^# ]]; then
        ip="${ip#\#}"
        iip=$(echo "$ip" | awk -F. '{printf "%03d.%03d.%03d.%03d", $1, $2, $3, $4}')
        BUILD="$BUILD{\"PHONE\":\"$device\",\"HOST\":\"$iip\",\"POOL\":\"NOT ON LIST\",\"MHS\":\"_____\"},"
    else
        RESPONSE=$(printf "{\"PHONE\":\"$device\",\"HOST\":\"$ip\",\""; $home_dir/api_pc.pl -c summary -a $ip -p $port | tr -d '\0' | sed -r \
        's/=/":"/g; s/;/\",\"/g' | sed 's/|/",/g')$(printf "\""; $home_dir/api_pc.pl -c pool -a $ip -p $port | tr -d \
        '\0' | sed -r 's/=/":"/g' | sed -r 's/;/\",\"/g' | sed 's/|/"},/g')
        iip=$(echo "$ip" | awk -F. '{printf "%03d.%03d.%03d.%03d", $1, $2, $3, $4}')
        if [[ "$RESPONSE" == *"No Connect"* ]]; then
            inact=$((inact+1))
            if [[ "$not_on" -eq "1" ]]; then
                BUILD="$BUILD{\"PHONE\":\"$device\",\"HOST\":\"$iip\",\"POOL\":\"OFF LINE\",\"MHS\":\"0.000\"},"
            else
                BUILD="$BUILD{\"PHONE\":\"$device\",\"HOST\":\"$iip\",\"POOL\":\"OFF LINE___\",\"MHS\":\"0.000\"},"
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
rm "$home_dir/dev_no_act.list"
mv "$home_dir/dev_no_act.tmp" "$home_dir/dev_no_act.list"
iteration=$(<"$home_dir/iteration.txt")
iteration=$((iteration + 1))
echo $iteration > "$home_dir/iteration.txt"
cur_time=$(date +'%T')
data=$(python3 $home_dir/minestat_api_VRSC.py)
data2=$(echo "$data" | sed "s/'/\"/g")
reward=$(python3 -c "import json, sys; data = json.load(sys.stdin); print(data[0]['reward'])" <<< "$data2")
price=$(python3 -c "import json, sys; data = json.load(sys.stdin); print(data[0]['price'])" <<< "$data2")
reward24MHs=$(echo "$reward * 1000000 * 24 * 0.000000001 " | bc)
my_reward=$(echo "scale=10; $reward24MHs * $mhsall" | bc)
my_reward_USDT=$(echo "scale=10; $my_reward * $price" | bc)
my_reward_USDT2=$(printf "%.2f" $my_reward_USDT)
my_reward2=$(printf "%.2f" $my_reward)
BUILD="${BUILD::-1}"
JSON=$BUILD"]"
SUMMARY="["
SUMMARY=$SUMMARY"{\"PHONE\":\" all $all \",\"HOST\":\"miners =\",\"POOL\":\" $mhsall \",\"MHS\":\" MHs \"},"
SUMMARY=$SUMMARY"{\"PHONE\":\" active =\",\"HOST\":\" $act \",\"POOL\":\" inactive \/ off =\",\"MHS\":\" $inact \/ $off \"},"
SUMMARY=$SUMMARY"{\"PHONE\":\" VRSC/day =\",\"HOST\":\" $my_reward2 \",\"POOL\":\" USDT/day =\",\"MHS\":\" $my_reward_USDT2 \"},"
SUMMARY=$SUMMARY"{\"PHONE\":\" time =\",\"HOST\":\" $cur_time \",\"POOL\":\" iteration =\",\"MHS\":\" $iteration \"}"
SUMMARY=$SUMMARY"]"
echo -e "$SUMMARY" > $home_dir/summary.list
echo $JSON
