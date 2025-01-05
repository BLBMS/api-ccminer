import requests

# URL API-ja
url = "https://api.minerstat.com/v2/coins"

# Parametri za zahtevo
params = {
    "list": "VRSC"
}

# Izvedi GET zahtevo
response = requests.get(url, params=params)

# Preveri, ali je zahteva uspešna
if response.status_code == 200:
    data = response.json()

    # POVEČAM vrednost 'reward' za 1000000000 oz. 1xE9
    reward = data[0]['reward']
    reward_E9 = reward * 1e9
    data[0]['reward'] = reward_E9

    print(data)  # Izpiše odgovor API-ja
else:
    print("Napaka pri pridobivanju podatkov:", response.status_code)
