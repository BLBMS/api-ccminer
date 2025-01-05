# python
# v.2025-01-05
# by blbMS

import requests

url = "https://api.minerstat.com/v2/coins"

params = {
    "list": "VRSC"
}

response = requests.get(url, params=params)

if response.status_code == 200:
    data = response.json()

    reward = data[0]['reward']
    reward_E9 = reward * 1e9
    data[0]['reward'] = reward_E9

    print(data)
else:
    print("Error: no data", response.status_code)
