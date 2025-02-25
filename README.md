# api-ccminer

Adds a summary for all miners, based on Oink's API monitoring.

## Installation

Copy to your home directory:

```bash
F="api-ccminer-setup.sh"; cd ~/; rm -f $F; wget https://raw.githubusercontent.com/BLBMS/api-ccminer/main/$F; chmod +x $F; ./$F
```

## Features

Displays:
Total hashrate of all miners
Number of active and inactive miners, as well as unreachable devices from dev.list.
Estimated revenue in VRSC and USDT 
Output time and number of output iterations (for performance monitoring)

Additionally:
Colors different mining pools for easier identification
Highlights hashrates below 1 MH/s or above specific thresholds (e.g., >2, >3 ... >9 MH/s)

## Oink's Android Mining Monitoring Tool

https://github.com/Oink70/Android-Mining/tree/main/monitoring

Read Oink's README.md first!
Thanks, Oink! 😄

This tool is tailored to my needs, with each miner's performance displayed in MH/s (mega hashes per second).
Customization requires some prior programming knowledge.

## Requirements

During the installation process, the following dependencies will be installed automatically:
```bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt install python3 -y
sudo apt install python3-pip -y
pip3 install requests
sudo apt install nano screen bc jq -y
```

## Disclaimer

These programs are provided "AS IS," without any warranties, express or implied. The author does not take responsibility for any direct or indirect damage caused by their use. Use them at your own risk.
If you are unsure about their functionality or potential impact, do not proceed.
No support provided. Report bug on Discord.

## Donation
If you find this program useful and appreciate my effort, you can support me by donating for a coffee or, even better, for a beer. 🍺 Cheers!
Your generosity is greatly appreciated.

VRSC
```
zs1u32sumn5pfn9va68wk6cmw60jmlsl5elt2vdrrxa0qvcgeatvvq5zp96ewyrczwg2q3e78ycctp
```

## Configuration

### config.json
Add at the end in your config.json
Allows access for this IP range. Adjust according to your network setup.
```json
"api-allow": "0.0.0.0/0",
```
Enables the API, binding it to the specified IP address and port. 0.0.0.0 indicates all adapters and IPs. Change to your port.
```json
"api-bind": "0.0.0.0:4068",
```

### dev.list
Edit the dev.list file to include the IPs and names of miners. Each line should include the miner's IP address and name, separated by a tab or space. You can optionally add a description. End the file with a blank line.

Lines starting with ### are ignored.
Lines starting with ### # are marked as NOT_ON_LIST.

Example:
```shell
###   ### - line ignored
###   #   - set to NOT_ON_LIST
### worker_IP   worker_name   custom_text
192.168.100.110  Miner
127.1.0.111  Worker
#127.1.0.112  badWorker  in_service
192.168.102.1     A30a  no_screen
192.168.102.7     A30g
###192.168.102.8     A30h  waiting_for_repair
192.168.102.51     A41a
192.168.102.52     A41b

```

### mydata.json
Customize this file to suit your setup:

```json
{
  "home_dir": "/home/user/api-ccminer",            // Automatically set
  "port": 4068,                                    // Change if different
  "time_zone": "Europe/Berlin",                    // Change if needed (see /usr/share/zoneinfo for options)
  "device_list": "dev.list",
  "refreshing_min": 10,                            // Refresh interval in minutes (must be > elapsed time for worker output)
  "not_on_list": 1,                                // Set to 1 to hide workers marked with #
  "pool_1": "verus.io",                            // Match names exactly as in config.json
  "pool_2": "vipor",
  "pool_3": "luckpool",
  "pool_4": "zerg",
  "pool_5": "farm",
  "pool_6": "MRR"
}
```

### Aliases
The following aliases will be added during setup:

```bash
alias wa='~/api-ccminer/watch.sh'                       # Start monitoring
alias rw='screen -x Watch'                              # Attach to the screen
alias was='~/api-ccminer/wsummary.sh'                   # Show only the summary
alias wan='~/api-ccminer/no_act.sh'                     # Show only inactive devices
alias xw='screen -S Watch -X quit 1>/dev/null 2>&1'     # Stop the screen
alias sl='screen -ls'                                   # List all screens
```

## Screenshot for reference
"not_on_list": 0, 
![API CCminer Screenshot](api-ccminer_0.png)

"not_on_list": 1, 
![API CCminer Screenshot](api-ccminer_1.png)

