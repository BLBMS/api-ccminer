#!/bin/bash
# v.2025-01-05
# by blbMS

echo "--- api-ccminer ---"
echo
echo "update & install"
echo "enter your sudo password if necessary"
sleep 2

sudo apt-get update
sudo apt-get upgrade -y
sudo apt install python3 -y
sudo apt install python3-pip -y
pip3 install requests
sudo apt install nano screen bc jq -y

sdir=$(dirname "$(readlink -f "$0")")
cd ~

base_name="api-ccminer"
if [ -d "$base_name" ]; then
  counter=1
  while [ -d "${base_name}.${counter}" ]; do
    counter=$((counter + 1))
  done
  mv "$base_name" "${base_name}.${counter}"
  echo "existing folder '$base_name' reneimed to '${base_name}.${counter}'"
fi

git clone https://github.com/BLBMS/api-ccminer.git

cd api-ccminer/

find . -type f \( -name "*.sh" -o -name "*.py" -o -name "*.pl" \) -exec chmod +x {} \;

echo "done"
echo
echo "added to .bashrc"
echo
echo "wa='~/api-ccminer/watch.sh'                        start"
echo "rw='screen -x Watch'                               show screen"
echo "was='~/api-ccminer/wsummary.sh'                    show only summary"
echo "wan='~/api-ccminer/no_act.sh'                      show only not active devices"
echo "xw='screen -S Watch -X quit 1>/dev/null 2>&1'      stop screens"
echo "sl='screen -ls'                                    list screens"

alias wa='~/api-ccminer/watch.sh'                       # start
alias rw='screen -x Watch'                 e             # show screen
alias was='~/api-ccminer/wsummary.sh'                   # show only summary
alias wan='~/api-ccminer/no_act.sh'                     # show only not active devices
alias xw='screen -S Watch -X quit 1>/dev/null 2>&1'     # stop screens
alias sl='screen -ls'                                   # list screens

echo "" >> ~/.bashrc
echo "#     alias api-ccminer" >> ~/.bashrc
echo "alias wa='~/api-ccminer/watch.sh'" >> ~/.bashrc
echo "alias rw='screen -x Watch'" >> ~/.bashrc
echo "alias was='~/api-ccminer/wsummary.sh'" >> ~/.bashrc
echo "alias wan='~/api-ccminer/no_act.sh'" >> ~/.bashrc
echo "alias xw='screen -S Watch -X quit 1>/dev/null 2>&1'" >> ~/.bashrc
echo "alias sl='screen -ls'" >> ~/.bashrc

rm -f $sdir/api-ccminer-setup.sh
