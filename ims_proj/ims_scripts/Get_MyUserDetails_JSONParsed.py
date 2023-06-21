#
# Get User MY ID
# 
# Authored by: Joemel John A Diente <JoemelJohn.Diente@microchip.com>
import json
import requests
import configparser

#Get details from api.cfg
config = configparser.ConfigParser()
config.read("api.cfg")

personal_access_token = config.get("ims_env", "personal_access_token")
api_base_url = config.get("ims_env", "api_base_url")

#API
url = api_base_url + "/users/me"

headers = {
    "accept": "application/json" ,
    "Authorization": "Bearer " + personal_access_token
}

response = requests.get(url, headers=headers)

#Parse JSON from response.text
data = json.loads(response.text)

#Pretty Print JSON
json_formatted_str = json.dumps(data, indent=2)
print(json_formatted_str)