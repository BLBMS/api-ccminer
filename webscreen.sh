#!/bin/bash
# v.2025-04-18.003
# by blbMS
version="v.038"
clear
tput clear
home_dir=$(dirname "$(readlink -f "$0")")
mydata_json="$home_dir/mydata.json"
refreshing_min=$(jq -r '.refreshing_min' $mydata_json)
web_dir=$(jq -r '.web_dir' "$mydata_json" | sed "s|^~|$HOME|")
set_colors=$(jq -r '.colors' $mydata_json)
SSH_rsa=$(jq -r '.SSH_rsa' "$mydata_json" | sed "s|^~|$HOME|")
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add "$SSH_rsa" > /dev/null 2>&1
device_list="$home_dir/$device_list"
device_json="$home_dir/check-all.json"
device_last="$home_dir/check-all.last"
summary_json="$home_dir/summary.json"
dev_on_list="$home_dir/dev_on.list"
noact_list="$home_dir/dev_no_act.list"
noact_tmp="$home_dir/dev_no_act.tmp"
data_json="$home_dir/data.json"
sort_json="$home_dir/sort.json"
web_json="$web_dir/data.json"
iteration_txt="$HOME/iteration.txt"
cd "$home_dir"
> "$device_json"
> "$summary_json"
> "$dev_on_list"
> "$noact_list"
source "$home_dir/functions.sh"
colors
clear
sleep 1
echo -e "api-ccminer        refreshing every $refreshing_min min        by blbMS 2025    $version\n"
if [ "$set_colors" = "1" ]; then
    echo -ne "\e[3;1H\e[K${Yellow}Start time: $start_time_display            ${White}preparing data ..."
else
    echo -ne "\e[3;1H\e[KStart time: $start_time_display            preparing data ..."
fi
while true; do
    web_dir=$(jq -r '.web_dir' "$mydata_json" | sed "s|^~|$HOME|")
    refreshing_min=$(jq -r '.refreshing_min' $mydata_json)
    port=$(jq -r '.port' $mydata_json)
    webjson=$(jq -r '.webjson' $mydata_json)
    device_list=$(jq -r '.device_list' $mydata_json)
    not_on_list=$(jq -r '.not_on_list' $mydata_json)
    set_dev_line=$(jq -r '.dev_in_line' $mydata_json)
    ip_prefix=$(jq -r '.ip_prefix' $mydata_json)
    repair=$(jq -r '.repair' $mydata_json)
    start_time=$(date +%s%3N)
    start_time_display=$(date -d "@$((start_time / 1000))" +'%H:%M:%S')
    > "$device_json"
    read_api
    rm -f "$device_last"
    if [ -f "$device_json" ]; then
        if [ -s "$device_json" ]; then
                jq -r '.[] | "\(.PHONE) \(.HOST) \(.POOL) \(.MHS)"' "$device_json" > "$device_last"
        fi
    fi
    making_summary
    sorted_devices
    > "$data_json"
    cp "$device_json" "$data_json"
    sed -i 's/_//g' "$data_json"
    if [[ -n "$ip_prefix" ]]; then
        sed -i "s/${ip_prefix}//g" "$data_json"
    fi
    curr_date_time=$(date '+%H:%M:%S %d.%m.%Y')
    jq --arg date "$curr_date_time" '{ DATE: [$date], DATA: . }' "$data_json" > "${data_json}.tmp" && mv "${data_json}.tmp" "$data_json"
    jq '. + {SUMM: [input]}' "$data_json" "$summary_json" > "${data_json}.tmp" && mv "${data_json}.tmp" "$data_json"
    jq -c --argfile sort "$sort_json" '. + $sort' "$data_json" > "${data_json}.tmp" && mv "${data_json}.tmp" "$data_json"
    if [ "$webjson" = "1" ]; then
        cp "$data_json" "$web_json"
        web-json > /dev/null 2>&1
    fi
    jq --argfile sort "$data_json" > "${data_json}.tmp" && mv "${data_json}.tmp" "$data_json"
    end_time=$(date +%s%3N)
    total_time=$((end_time - start_time))
    total_seconds=$((total_time / 1000))
    milliseconds=$((total_time % 1000))
    hours=$((total_seconds / 3600))
    minutes=$(( (total_seconds % 3600) / 60 ))
    seconds=$((total_seconds % 60))
    elapsed_time=$(printf "%02d:%02d:%02d.%03d" $hours $minutes $seconds $milliseconds)
    end_time_display=$(date -d "@$((end_time / 1000))" +'%H:%M:%S')
    POOL1=$(jq -r '.pool_1' $mydata_json)
    POOL2=$(jq -r '.pool_2' $mydata_json)
    POOL3=$(jq -r '.pool_3' $mydata_json)
    POOL4=$(jq -r '.pool_4' $mydata_json)
    POOL5=$(jq -r '.pool_5' $mydata_json)
    POOL6=$(jq -r '.pool_6' $mydata_json)
    POOL7=$(jq -r '.pool_7' $mydata_json)
    POOL8=$(jq -r '.pool_8' $mydata_json)
    POOL9=$(jq -r '.pool_9' $mydata_json)
    POOL10=$(jq -r '.pool_10' $mydata_json)
    POOL11=$(jq -r '.pool_11' $mydata_json)
    POOL12=$(jq -r '.pool_12' $mydata_json)
    POOL13=$(jq -r '.pool_13' $mydata_json)
    POOL14=$(jq -r '.pool_14' $mydata_json)
    POOL15=$(jq -r '.pool_15' $mydata_json)
    PColor1=$(jq -r '.pcolor_1' $mydata_json)
    PColor2=$(jq -r '.pcolor_2' $mydata_json)
    PColor3=$(jq -r '.pcolor_3' $mydata_json)
    PColor4=$(jq -r '.pcolor_4' $mydata_json)
    PColor5=$(jq -r '.pcolor_5' $mydata_json)
    PColor6=$(jq -r '.pcolor_6' $mydata_json)
    PColor7=$(jq -r '.pcolor_7' $mydata_json)
    PColor8=$(jq -r '.pcolor_8' $mydata_json)
    PColor9=$(jq -r '.pcolor_9' $mydata_json)
    PColor10=$(jq -r '.pcolor_10' $mydata_json)
    PColor11=$(jq -r '.pcolor_11' $mydata_json)
    PColor12=$(jq -r '.pcolor_12' $mydata_json)
    PColor13=$(jq -r '.pcolor_13' $mydata_json)
    PColor14=$(jq -r '.pcolor_14' $mydata_json)
    PColor15=$(jq -r '.pcolor_15' $mydata_json)
    set_columns=$(jq -r '.columns' $mydata_json)
    set_colors=$(jq -r '.colors' $mydata_json)
    set_dev_line=$(jq -r '.dev_in_line' $mydata_json)
    refreshing_min=$(jq -r '.refreshing_min' $mydata_json)
    color_brackets=$(jq -r '.color_brackets' $mydata_json)
    color_ip=$(jq -r '.color_ip' $mydata_json)
    color_name=$(jq -r '.color_name' $mydata_json)
    print_apis=$(jq -r '.print_apis' $mydata_json)
    print_summary=$(jq -r '.print_summary' $mydata_json)
    print_devices=$(jq -r '.print_devices' $mydata_json)
    rows=$(tput lines)
    cols=$(tput cols)
    max_polje=$(($max_length + $pool_len + 35))
    if [ "$set_columns" = "0" ]; then
        st_polj=$(( cols / max_polje ))
        print_columns=$st_polj
    else
        print_columns=$set_columns
    fi
    Brackets=${!color_brackets}
    IPcol=${!color_ip}
    NameCol=${!color_name}
    PColor1=${!PColor1}
    PColor2=${!PColor2}
    PColor3=${!PColor3}
    PColor4=${!PColor4}
    PColor5=${!PColor5}
    PColor6=${!PColor6}
    PColor7=${!PColor7}
    PColor8=${!PColor8}
    PColor9=${!PColor9}
    PColor10=${!PColor10}
    PColor11=${!PColor11}
    PColor12=${!PColor12}
    PColor13=${!PColor13}
    PColor14=${!PColor14}
    PColor15=${!PColor15}
    if [ "$set_colors" = "1" ]; then
        clear
        tput clear
        echo -e "api-ccminer        refreshing every $refreshing_min min        by blbMS 2025    $version\n"
        echo -e "${Yellow}Start time: $start_time_display   ${Red}End time: $end_time_display   ${Green}Elapsed time (API's): ${elapsed_time}${White}"
        echo
        if [ "$print_apis" = "1" ]; then
            cat "$device_json" | jq -c '.[] | [.PHONE,.HOST,.POOL,.MHS]' | sed \
                -e "s/\b\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\)\b/${IPcol}\1${Brackets}/g" \
                -e "s/\(null\)/${Red}\1${Brackets}/g" \
                -e "s/\"\(0\.\)/\"${Red}\1${Red}/g" \
                -e "s/\"\(1\.\)/\"${iRed}\1${iRed}/g" \
                -e "s/\"\(2\.\)/\"${Yellow}\1${Yellow}/g" \
                -e "s/\"\(3\.\)/\"${iGray}\1${iGray}/g" \
                -e "s/\"\(4\.\)/\"${White}\1${White}/g" \
                -e "s/\"\(5\.\)/\"${iBlue}\1${iBlue}/g" \
                -e "s/\"\(6\.\)/\"${Blue}\1${Blue}/g" \
                -e "s/\"\(7\.\)/\"${iMagenta}\1${iMagenta}/g" \
                -e "s/\"\(8\.\)/\"${iGreen}\1${iGreen}/g" \
                -e "s/\"\(9\.\)/\"${iYellow}\1${iYellow}/g" \
                -e "s/\($POOL1\)/${PColor1}\1${Brackets}/g" \
                -e "s/\($POOL2\)/${PColor2}\1${Brackets}/g" \
                -e "s/\($POOL3\)/${PColor3}\1${Brackets}/g" \
                -e "s/\($POOL4\)/${PColor4}\1${Brackets}/g" \
                -e "s/\($POOL5\)/${PColor5}\1${Brackets}/g" \
                -e "s/\($POOL6\)/${PColor6}\1${Brackets}/g" \
                -e "s/\($POOL7\)/${PColor7}\1${Brackets}/g" \
                -e "s/\($POOL8\)/${PColor8}\1${Brackets}/g" \
                -e "s/\($POOL9\)/${PColor9}\1${Brackets}/g" \
                -e "s/\($POOL10\)/${PColor10}\1${Brackets}/g" \
                -e "s/\($POOL11\)/${PColor11}\1${Brackets}/g" \
                -e "s/\($POOL12\)/${PColor12}\1${Brackets}/g" \
                -e "s/\($POOL13\)/${PColor13}\1${Brackets}/g" \
                -e "s/\($POOL14\)/${PColor14}\1${Brackets}/g" \
                -e "s/\($POOL15\)/${PColor15}\1${Brackets}/g" \
                -e "s/\(NOT-ON-LIST\)/${iRed}\1${Brackets}/g" \
                -e "s/\(OFF-LINE\)/${Red}\1${Brackets}/g" \
                -e "s/\(\[\"\)/${Brackets}\1${NameCol}/g" \
                -e "s/\(_\)/${Gray}\1${Brackets}/g" \
                -e "s/\(\",\"\)/${Brackets}\1${Brackets}/g" \
                -e "s/\(\"]\)/${Brackets}\1${Brackets}/g" \
                | column -t | awk '
                {
                    row[NR] = $0;
                }
                END {
                    cols = int(NR / '"$print_columns"');
                    if (NR % '"$print_columns"' != 0) cols++;

                    for (i = 1; i <= cols; i++) {
                        for (j = i; j <= NR; j += cols) {
                            printf "%-25s ", row[j];
                        }
                        print "";
                    }
                }'
        fi
    else
        clear
        tput clear
        echo -e "api-ccminer        refreshing every $refreshing_min min        by blbMS 2025    $version\n"
        echo "Start time: $start_time_display   End time: $end_time_display   Elapsed time: ${elapsed_time}"
        echo
        if [ "$print_apis" = "1" ]; then
            cat "$device_json" | jq -c '.[] | [.PHONE,.HOST,.POOL,.MHS]' \
                | column -t | awk '
                {
                    row[NR] = $0;
                }
                END {
                    cols = int(NR / '"$print_columns"');
                    if (NR % '"$print_columns"' != 0) cols++;

                    for (i = 1; i <= cols; i++) {
                        for (j = i; j <= NR; j += cols) {
                            printf "%-25s ", row[j];
                        }
                        print "";
                    }
                }'
            echo
        fi
    fi
    if [ "$print_summary" = "1" ]; then
        if [ "$set_colors" = "1" ]; then
            echo
            echo -e "${iWhite}Summary  \e[0m"
            summary
        else
            echo
            echo "Summary  "
            summaryBW
        fi
    fi
    if [ "$print_devices" > "0" ]; then
        if [ "$set_colors" = "1" ]; then
            echo
            echo -e "${iWhite}Sorted devices  \e[0m"
            sorted_devices
            print_sorted_devices
        else
            echo
            echo "Sorted devices  "
            sorted_devices
            print_sorted_devices
        fi
    fi
    echo
    unset pool_names
    unset all_pools
    refreshing_min=$(jq -r '.refreshing_min' $mydata_json)
    next_time=$((start_time + refreshing_min * 60000))
    next_time_display=$(date -d "@$((next_time / 1000))" +'%H:%M:%S')
    finish_time=$(date +%s)
    wait_time=$((next_time / 1000 - finish_time))
    if (( wait_time < 0 )); then wait_time=0; fi
    DIFF_H=$((wait_time / 3600))
    DIFF_M=$(((wait_time % 3600) / 60))
    DIFF_S=$((wait_time % 60))
    if [ "$set_colors" = "1" ]; then
        echo -e "${Yellow}Sleeping for: ${Green}$DIFF_H${Yellow} h ${Green}$DIFF_M${Yellow} m ${Green}$DIFF_S${Yellow} s\e[0m"
        echo -e "${Yellow}Next refresh: $next_time_display  \e[0m"
        sleep "$wait_time"
    else
        echo -e "Sleeping for: $DIFF_H h $DIFF_M m $DIFF_S s\e[0m"
        echo -e "Next refresh: $next_time_display  \e[0m"
        sleep "$wait_time"
    fi
    ((iteration++))
done
