# api-ccminer
adds summary for all miners - based on Oinks-API monitoring

for install > copy to ~/

```
F="api-ccminer-setup.sh";cd ~/;rm -f $F;wget https://raw.githubusercontent.com/BLBMS/api-ccminer/main/$F;chmod +x $F;./$F
```

displays:
- sum of all miners hashrate
- number of active and inactive miners and number unreachable devices from .list (OFF)
- assumed revenue in VRSC and USDT
- output time and number of output iterations (for performance control)

additionally:
- colors the different pools in different colors
- specially colors all hashrates that are less than 1, >2, >3 ... >9 MHs

______________

https://github.com/Oink70/Android-Mining/tree/main/monitoring

read Oink's README.md first!!

thx Oink :D

tailored to my needs, each miner is in MHs (mega hash / s)

customization requires some prior programming knowledge

you definitely need this - automatic installation in the installation process:
```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo pip3 install requests
sudo apt install nano screen bc jq -y
```

**no help, use at your own risk**

**if you don't know what to do, don't do anything**

______________
## your config.json

```
allows access for this IP range. Adjust to your own situation.
"api-allow": "0.0.0.0/0",
enables the API by making it listen on the specified IP address and port. 0.0.0.0 signifies all adapters and IPs.
"api-bind": "0.0.0.0:4068"
```
______________
## dev.list

edit file `dev.list` containing the IPs of the miners (xxx.xxx.xxx.xxx) and the name of that miner separated by one tab or space, one per line, than you cam add descriptin add a blank line at the end of the file

```
###   ### - line ignored
###   #   - set to NOT_LISTED
### worker_IP   worker_name   custom_text
192.168.100.110  Miner
127.1.0.111  Worker
#127.1.0.112  badWorker  in_servis
192.168.102.1     A30a  no screen
192.168.102.7     A30g
###192.168.102.8     A30h  waiting for repair
192.168.102.51     A41a
192.168.102.52     A41b
```
______________
## mydata.json

change to your needs
```
{
  "home_dir": "/home/user/api-ccminer",                      - change automatically
  "port": 4068,                                              - change if different
  "time_zone": "Europe/Berlin",                              - change if different > ls /usr/share/zoneinfo
  "device_list": "dev.list",
  "refreshing_min": 10,                                      - refresh time in minutes (must be greater than the elapsed time, see above the workers output)
  "not_on_list": 1,                                          - if it is 1, it does not display workers marked with #
  "pool_1": "verus.io",                                      - change (exactly) names as you have them in config.json
  "pool_2": "vipor",
  "pool_3": "luckpool",
  "pool_4": "zerg",
  "pool_5": "farm",
  "pool_6": "MRR"
}
```
______________
## set up aliases

added during setup automatically
```
alias wa='~/api-ccminer/watch.sh'                       # start
alias rw='screen -x Watch'                              # show screen
alias was='~/api-ccminer/wsummary.sh'                   # show only summary
alias wan='~/api-ccminer/no_act.sh'                     # show only not active devices
alias xw='screen -S Watch -X quit 1>/dev/null 2>&1'     # stop screens
alias sl='screen -ls'                                   # list screens
```
