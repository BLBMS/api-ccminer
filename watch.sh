#!/bin/bash
# v.2025-01-05
# by blbMS

script_dir=$(dirname "$(readlink -f "$0")")
data_json="$script_dir/mydata.json"
data_tmp="$script_dir/mydata.tmp"
jq --arg script_dir "$script_dir" '.home_dir = $script_dir' $data_json > $data_tmp && mv $data_tmp $data_json
home_dir=$(jq -r '.home_dir' $data_json)
refreshing_min=$(jq -r '.refreshing_min' $data_json)
device_list=$(jq -r '.device_list' $data_json)
refreshing=$((refreshing_min * 60))
i=1
echo -e "Not listed:\n"
while read -r line; do
    if ! [[ $line =~ ^### ]]; then
        if [[ $line =~ ^# ]]; then
            first_field=$(echo "${line:1}" | awk '{print $1}')
            second_field=$(echo "${line:1}" | awk '{print $2}')
            length=${#first_field}
            spaces=$((15 - length))
            space_string=$(printf '%*s' "$spaces")
            lengthi=${#i}
            spacesi=$((3 - lengthi))
            space_stringi=$(printf '%*s' "$spacesi")
            echo -e "\e[0m$i$space_stringi   $first_field$space_string\e[93m   $second_field \e[0m"
            ((i++))
        fi
    fi
done < $home_dir/$device_list
rm -f $home_dir/iteration.txt
echo "0" >> $home_dir/iteration.txt
screen -wipe 1>/dev/null 2>&1
if screen -ls | grep -i Watch; then
  printf "\n\e[93m WATCH is already running! 'rw' to see \e[0m\n"
  sleep 2
  screen -r Watch
else
  printf "\n\e[93m Starting WATCH! \e[0m\n"
  screen -S Watch -X quit 1>/dev/null 2>&1
  screen -wipe 1>/dev/null 2>&1
  screen -dmS Watch 1>/dev/null 2>&1
  screen -S Watch -X stuff "clear \n" 1>/dev/null 2>&1
  screen -S Watch -X stuff "watch -c -p -n $refreshing '${home_dir}/wscreen.sh'\n" 1>/dev/null 2>&1
fi
if screen -ls | grep -q "\bWATCH\b"; then
    printf "\n\e[93m screen WATCH is running\e[0m\n"
fi
printf "\n\e[93m open with: 'screen -r Watch' or 'rw' \n close with 'xw' \e[0m\n"
