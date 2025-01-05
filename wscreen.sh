#!/bin/bash
# v.2025-01-05
# by blbMS

script_dir=$(dirname "$(readlink -f "$0")")
data_json="$script_dir/mydata.json"
home_dir=$(jq -r '.home_dir' $data_json)
POOL1=$(jq -r '.pool_1' $data_json)
POOL2=$(jq -r '.pool_2' $data_json)
POOL3=$(jq -r '.pool_3' $data_json)
POOL4=$(jq -r '.pool_4' $data_json)
POOL5=$(jq -r '.pool_5' $data_json)
POOL6=$(jq -r '.pool_6' $data_json)
source "$home_dir/colors.sh"
rm -f "$home_dir/check-all.last"
if [ -f "$home_dir/check-all.list" ]; then
    cp "$home_dir/check-all.list" "$home_dir/check-all.last"
fi
time_zone=$(jq -r '.time_zone' $data_json)
export TZ="$time_zone"
start_time=$(date +%s%3N)
$home_dir/check-all.sh > "$home_dir/check-all.list"
end_time=$(date +%s%3N)
total_time=$((end_time - start_time))
total_seconds=$((total_time / 1000))
milliseconds=$((total_time % 1000))
hours=$((total_seconds / 3600))
minutes=$(( (total_seconds % 3600) / 60 ))
seconds=$((total_seconds % 60))
elapsed_time=$(printf "%02d:%02d:%02d.%03d" $hours $minutes $seconds $milliseconds)
start_time_display=$(date -d "@$((start_time / 1000))" +'%H:%M:%S')
end_time_display=$(date -d "@$((end_time / 1000))" +'%H:%M:%S')
echo -e "${Yellow}Start time: $start_time_display   ${Red}End time: $end_time_display   ${Green}Elapsed time: ${elapsed_time}${White}"
cat "$home_dir/check-all.list" | jq -c '.[] | [.PHONE,.HOST,.POOL,.MHS]' | sed \
-e "s/null/${Red}&${White}/g" \
-e "s/\"0\./${Red}&${Red}/g" \
-e "s/\"1\./${iRed}&${iRed}/g" \
-e "s/\"2\./${Yellow}&${Yellow}/g" \
-e "s/\"3\./${iGray}&${iGray}/g" \
-e "s/\"4\./${White}&${White}/g" \
-e "s/\"5\./${iBlue}&${iBlue}/g" \
-e "s/\"6\./${Blue}&${Blue}/g" \
-e "s/\"7\./${iMagenta}&${iMagenta}/g" \
-e "s/\"8\./${iGreen}&${iGreen}/g" \
-e "s/\"9\./${iYellow}&${iYellow}/g" \
-e "s/$POOL1/${xBlue}&${White}/g" \
-e "s/$POOL2/${Blue}&${White}/g" \
-e "s/$POOL3/${Green}&${White}/g" \
-e "s/$POLL4/${iGreen}&${White}/g" \
-e "s/$POOL5/${Yellow}&${White}/g" \
-e "s/$POOL6/${iYellow}&${White}/g" \
-e "s/NOT ON LIST/${iRed}&${White}/g" \
-e "s/OFF LINE/${Red}&${White}/g" \
-e "s/_/${Gray}&${White}/g" \
-e "s/\[\"/${White}&${Yellow}/g" \
-e "s/\",\"/${White}&${White}/g" \
-e "s/]/${White}&${White}/g" | column
echo
source $home_dir/wsummary.sh
echo
source $home_dir/no_act.sh
