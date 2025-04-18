# api-ccminer
## API monitoring on a freely accessible WEBSITE
The program lists all devices reachable via API in the WebWatch screen. It calculates a summary for all devices, including "Daily estimate coins" and "Daily estimate earnings". It sorts devices by pool and by (non)operation. Colors different mining pools for easier identification. Highlights hashrates below 1 MH/s or above specific thresholds (e.g., >2, >3 ... >9 MH/s)
The web page adapts to the width of the screen, so on mobile devices there is only one column, while on desktop the number of columns adjusts according to the current zoom of the page. The colors are fixed (current version) and are visible in the table under the devices.

The page is updated every minute. So, if the API scanning program updates every 15 minutes, the website will be updated approximately in the next minute. Please note that refreshing the data on the GitHub page can take up to a few minutes, and there is nothing I can do about it. There will still be new data every 15 minutes, but the data will be a few minutes old. Sending data too frequently (say every 2 minutes) leads to an even greater delay in the display.

## Oink's Android Mining Monitoring Tool

https://github.com/Oink70/Android-Mining/tree/main/monitoring

Read Oink's README.md first!
Thanks, Oink! 😄

This tool is tailored to my needs, with each miner's performance displayed in MH/s (mega hashes per second).
Customization requires some prior programming knowledge.

## Disclaimer
These programs are provided "AS IS," without any warranties, express or implied. The author does not take responsibility for any direct or indirect damage caused by their use. Use them at your own risk. 
By using the program with a public Github page, your data (miner names, partial or full IP, pool, hash of each miner, total hash, estimated profit in VRSC and USDT) will be publicly available to anyone who accesses your page. By installing and using the program, you assume all responsibility. The author of the program is not responsible for the disclosure of this or any other data on your page.
If you want to use the program only internally without a public Github page, set the parameter "webjson" to 0 in 'mydata.json' file.
If you are unsure about their functionality or potential impact, do not proceed.

No support provided. Report bug on Discord.

## Donation
If you find this program useful and appreciate my effort, you can support me by donating for a coffee or, even better, for a beer. 🍺 Cheers!
Your generosity is greatly appreciated.

VRSC
```
zs1u32sumn5pfn9va68wk6cmw60jmlsl5elt2vdrrxa0qvcgeatvvq5zp96ewyrczwg2q3e78ycctp
```

## Requirements
A Github account on https://github.com/ is required for the output on the website to work (accessible from anywhere).

Update and install
```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt install nano screen bc jq perl -y
sudo apt install python3 python3-pip -y
pip3 install requests
```

## Installation
Clone the main program
```
cd
git clone https://github.com/BLBMS/api-ccminer.git
cd api-ccminer
chmod +x *.sh
rm -rf pic/
```

On Github add new public repo named 'api-ccweb'. Do not add README, .gitignore or license. Go to repo and 'Add file' named 'data.json'. The content is anything and it doesn't matter. Go to 'Settings/Pages', in 'Source' set 'Deploy from a branch' in 'Branch' set 'main' and in 'Folder' set '/ (root)'.

Go to `https://github.com/settings/keys` and use your or add new SSH RSA Key. Copy both keys in '~/.ssh/'.
```cd ~/.ssh/```
Assign the correct permissions (replace xxx with the correct names of your files)
```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_xxx
chmod 644 ~/.ssh/id_xxx.pub
```

Clone repository (replace XXXXXX with the correct name of your repo)
```
cd
git clone https://github.com/XXXXXX/api-ccweb.git
cd api-ccweb
```

Set up git
`git remote -v`
If it prints  `... https://github.com/...` change with `git remote set-url origin git@github.com/XXXXX/api-ccweb.git` replace XXXXX with your github name and check again `git remote -v`, must be `... origin  git@github.com/...`
Test with `git status` and `ssh -T git@github.com`, answer is like `Hi XXXXXX! You've successfully authenticated,...`

Make pull and push
```
git pull --rebase origin main
git pull
git push
```

If all OK then move files and push to github
```
mv ~/api-ccminer/index.html .
mv ~/api-ccminer/favicon.ico .
git add index.html
git add favicon.ico
git commit -m "do not change or delete"
git push origin main
```
Check if you have this two files in your github/api-ccweb!

Add aliases in `nano ~/.bashrc`, add at end of file
```
alias sw='~/api-ccminer/webwatch.sh'
alias rw='screen -d -r WebWatch'
alias xw='screen -S WebWatch -X quit 1>/dev/null 2>&1'
```
Update `source ~/.bashrc`

## Configure your config.json
Add at the end in your config.json. Allows access for this IP range. Adjust according to your network setup. Enables the API, binding it to the specified IP address and port. 0.0.0.0 indicates all adapters and IPs. Change to your port.
```json
"api-allow": "0.0.0.0/0",
"api-bind": "0.0.0.0:4068",
```
## Setting parameters
Go to `cd ~/api-ccminer` and edit `nano mydata.json`
```json
"SSH_rsa": "~/.ssh/id_xxx", | Enter the private key file set above e.g. '~/.ssh/id_xxx', starting with `~/` is required.

"web_dir": "~/api-ccweb/", | Change here if you choose different site, starting with `~/` is required.

"device_list": "dev.list", | Change here if you choose different file name.

"port": 4068, | Use same port as is in config.json.

"refreshing_min": 15, | Change according to need. I don't recommend too often because of the impact on hash.

"webjson": 1, | 1=will send data to web site, 0=will not

"not_on_list": 0, | 1=also displays devices marked with ### in "device_list":

"columns": 0, | 1,2,3,..=fixed number of columns (in print_apis) 0=auto fit display size

"dev_in_line": 0, | 1,2,3,..=fixed number of devices (in print_devices) 0=auto

"colors": 1, | 1=output in WebWatch screen in colors 0=mono

"ip_prefix": "192.168.", | To shorten the length or cover up part of the IP, remove the specified part.

"print_apis": 1, | 1=print a table of devices with API data 0=will not

"print_summary": 1, | 1=print summary data 0=will not

"print_devices": 1, | 1=list all sorted devices by pool 2,3...=list only from the 2nd, 3rd ... most numerous onwards 0=no list

"pool_1": "verus", and
"pcolor_1": "iBlue", | It takes the poll names as you have them set in your config.json under "name" and not under "url". 1*

"color_brackets": "iGray", | This is the color of the brackets in the device table.

"color_name": "Yellow", | This is the color of the device names as defined in your config.json. 2*

"color_ip": "Blue", | This is the color of the IP in the device table.
```

1* Only the part of the name that matches will be colored. For example, for "vipor_DE" and "2nd_vipor_US" only the part "vipor" will be colored. Adjust the output and colors to your liking, and correct the config.json accordingly. I recommend choosing shorter tags due to the width of the output in tables.

2* I recommend choosing shorter names due to the width of the output in tables.

Important: Changing colors and displaying tables is only possible in the screen version. The web version cannot be customized (yet). Adjusting the font size and number of columns in api-ccweb is done with the mouse wheel and F5 to refresh.

## Add devices to list
Edit the dev.list file to include the IPs and names of miners. Each line should include the miner's IP address and name, separated by a tab or space. You can optionally add a description. End the file with a blank line.

Lines starting with ### are comment/ignored. Lines starting with # are marked as NOT_ON_LIST. This temporarily removes the device from processing without permanently erasing it.

Example:
```shell
###   ### - comment/line ignored
###   #   - set to NOT_ON_LIST
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

## Start
`~/api-ccminer/webwatch.sh` or `sw`

## Printout example
### Desktop - screen
![1](/pic/desktop_screen.jpg)
```json
  "print_apis": 0,
  "print_summary": 1,
  "print_devices": 2
```
![2](/pic/desktop_screen_2.jpg)
### Desktop - WEB
![3](/pic/desktop_web.jpg)
### Mobile - WEB
![4](/pic/mobile_web.jpg)
