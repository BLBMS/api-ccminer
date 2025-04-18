# api-ccminer
API monitoring on the WEB page

The program lists all devices reachable via API in the WebWatch screen. It calculates a summary for all devices, including "Daily estimate coins" and "Daily estimate earnings". It sorts devices by pool and by (non)operation.

A Github account on `https://github.com/` is required for the output on the website to work (accessible from anywhere). The page is updated every minute. So, if the API scanning program updates every 15 minutes, the website will be updated approximately in the next minute. There will still be new data every 15 minutes.

Clone the main program
```
cd
git clone https://github.com/BLBMS/api-ccminer.git
cd api-ccminer
chmod +x *.sh
```

On Github add new public repo named 'api-ccweb'. Do not add README, .gitignore or license. Go to repo and 'Add file' named 'data.json'. The content is anything and it doesn't matter. Go to 'Settings/Pages', in 'Source' set 'Deploy from a branch' in 'Branch' set 'main' and in 'Folder' set '/ (root)'.

Go to `https://github.com/settings/keys` and use your os add new SSH RSA Key. Copy both keys in '~/.ssh/'.
```cd ~/.ssh/```
Assign the correct permissions (fix xxx in the correct names of your files)
```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_xxx
chmod 644 ~/.ssh/id_xxx.pub
```

Clone repository (fix XXXXXX in the correct name of your repo)
```
cd
git clone https://github.com/XXXXXX/api-ccweb.git
cd api-ccweb
mv ~/api-ccminer/index.html .
mv ~/api-ccminer/favicon.ico .
```

Set up git
`git remote -v`
If it prints  ... https://github.com/...
change with
`git remote set-url origin git@github.com/XXXXX/api-ccweb.git`
replace XXXXX with your github name and check again
`git remote -v`
Must be ... origin  git@github.com/...

test
`git status`

Add aliases
`nano ~/.bashrc`
add at end of file
```
alias sw='~/api-ccminer/webwatch.sh'
alias rw='screen -d -r WebWatch'
alias xw='screen -S WebWatch -X quit 1>/dev/null 2>&1'
```
`source ~/.bashrc`

Set program settings
`cd ~/api-ccminer`
edit
`nano mydata.json`

"SSH_rsa": enter the private key file set above e.g. '~/.ssh/id_xxx', starting with `~/` is required

"web_dir": "~/api-ccweb/", change here if you choose different site, starting with `~/` is required

"device_list": "dev.list", change here if you choose different file name

"port": 4068, use same port as is in config.json

"refreshing_min": 15, change according to need

"webjson": 1, 1=will send data to web site, 0=will not

"not_on_list": 0, 1=also displays devices marked with ### in "device_list":

"columns": 0, 1,2,3,..=fixed number of columns (in print_apis) 0=auto fit display size

"dev_in_line": 0, 1,2,3,..=fixed number of devices (in print_devices) 0=auto

"colors": 1, 1=output in WebWatch screen in colors 0=mono

"ip_prefix": "192.168.", to shorten the length or cover up part of the IP, remove the specified part

"print_apis": 1, 1=print a table of devices with API data 0=will not

"print_summary": 1, 1=print summary data 0=will not

"print_devices": 1, 1=list sorted devices by pool 0=will not
