#!/bin/bash
# v.2025-04-17.002
# by blbMS

home_dir=$(dirname "$(readlink -f "$0")")
data_json="$home_dir/mydata.json"
start_api_ccminer="$home_dir/webscreen.sh"
device_list=$(jq -r '.device_list' $data_json)
iteration_txt="$home_dir/iteration.txt"
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
done < "$home_dir/$device_list"
echo "0" > "$iteration_txt"
screen -wipe 1>/dev/null 2>&1
if screen -ls | grep -i WebWatch; then
  printf "\n\e[93m WebWatch is already running! 'rw' to see \e[0m\n"
  sleep 2
  screen -r WebWatch
else
  printf "\n\e[93m Starting WebWatch (api-ccminer)! \e[0m\n"
  screen -S WebWatch -X quit 1>/dev/null 2>&1
  screen -wipe 1>/dev/null 2>&1
  screen -dmS WebWatch 1>/dev/null 2>&1
  screen -S WebWatch -X stuff "tput clear && sleep 0.5 && $start_api_ccminer\n" 1>/dev/null 2>&1
fi
printf "\n\e[93m open with: 'screen -r WebWatch' or 'rw' \n start with 'sw' \n close with 'xw' \e[0m\n"
# move aliases to .bashrc
alias sw='~/api-ccminer/webwatch.sh'
alias rw='screen -d -r WebWatch'
alias xw='screen -S WebWatch -X quit 1>/dev/null 2>&1'
