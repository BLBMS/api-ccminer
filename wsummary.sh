#!/bin/bash
# v.2025-01-05
# by blbMS

script_dir=$(dirname "$(readlink -f "$0")")
data_json="$script_dir/mydata.json"
home_dir=$(jq -r '.home_dir' $data_json)
source "$home_dir/colors.sh"
cat "$home_dir/summary.list" | jq -c '.[] | [.PHONE,.HOST,.POOL,.MHS]' | sed \
-e "s/ all /${iYellow}&${iYellow}/g" \
-e "s/ active /${iGreen}&${iGreen}/g" \
-e "s/ inactive /${iRed}&${iRed}/g" \
-e "s/ VRSC\/day/${iBlue}&${iBlue}/g" \
-e "s/ USDT\/day/${iWhite}&${iWhite}/g" \
-e "s/ time =/${Yellow}&${Yellow}/g" \
-e "s/ iteration/${iMagenta}&${iMagenta}/g" \
-e "s/]/${C_Off}&${C_Off}/g"
