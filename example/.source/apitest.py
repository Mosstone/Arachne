#!/usr/bin/env python


import requests
import json

name = 'white russian'
api_url = 'https://api.api-ninjas.com/v1/cocktail?name={}'.format(name)
response = requests.get(api_url, headers={'X-Api-Key': '0pzBI/jyHzb1z/UQBeg7xQ==VchjgyFnGNFoshdG'})
if response.status_code == requests.codes.ok:
    print(json.dumps(json.loads(response.text), indent=4))
else:
    print("Error:", response.status_code, response.text)
