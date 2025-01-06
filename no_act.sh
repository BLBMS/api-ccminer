#!/bin/bash
# v.2025-01-05
# by blbMS

script_dir=$(dirname "$(readlink -f "$0")")
data_json="$script_dir/mydata.json"
home_dir=$(jq -r '.home_dir' $data_json)
input_file="$home_dir/dev_no_act.list"
header=$(head -n 1 "$input_file")
device_count=$(tail -n +2 "$input_file" | wc -l)
header="$header ($device_count)"
echo -e "\e[93m$header\e[0m"
device_names=$(tail -n +2 "$input_file" | awk '{print $2}' | sed 's/_*$//')
N=10
count=0
colors=("\e[94m" "\e[92m" "\e[96m" "\e[1;93m" "\e[91m")
for name in $device_names; do
  color=${colors[$((count % ${#colors[@]}))]}
  echo -ne "$color$name\e[0m "
  ((count++))
  if ((count % N == 0)); then
    echo
  fi
done
if ((count % N != 0)); then
  echo
fi
