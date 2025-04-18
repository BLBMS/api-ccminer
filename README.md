# api-ccminer
API monitoring on the WEB page

```
cd
git clone https://github.com/BLBMS/api-ccminer.git
cd api-ccminer
chmod +x *.sh
```

```
cd
git clone https://github.com/BLBMS/api-ccweb.git
cd api-ccweb
mv ~/api-ccminer/index.html .
mv ~/api-ccminer/favicon.ico .
```
`git remote -v`
if  ... https://github.com/...
change
`git remote set-url origin git@github.com/XXXXX/api-ccweb.git`
replace XXXXX with your github name and check again
`git remote -v`
... origin  git@github.com/...

test
`git status`


`nano ~/.bashrc`
add at end of file
```
alias sw='~/api-ccminer/webwatch.sh'
alias rw='screen -d -r WebWatch'
alias xw='screen -S WebWatch -X quit 1>/dev/null 2>&1'
```
`source ~/.bashrc`

`cd ~/api-ccminer`
edit
`nano mydata.json`

"SSH_rsa":
set your rsa_id for github
(go to your github profile - settings - SSH and GPG keys)

"web_dir": "~/api-ccweb/", change here if you choose different site

"device_list": "dev.list", change here if you choose different file name

"port": 4068, use same port as is in config.json

"refreshing_min": 15, change according to need

"webjson": 1, 1=will send data to web site, 0=will not

"not_on_list": 0, 1=also displays devices marked with ### in "device_list":
"columns": 0, 1,2,3,..=fixed number of columns (in print_apis) 0=auto fit display size
"dev_in_line": 0, 1,2,3,..=fixed number of devices (in print_devices) 0=auto
"colors": 1, 1=output in WebWatch screen in colors 0=mono
