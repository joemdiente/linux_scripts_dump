# 
# Checkout Asset using Asset ID
#
# Authored by: Joemel John A Diente 
import json
import requests
import configparser

#Get details from api.cfg
config = configparser.ConfigParser()
config.read("api.cfg")

personal_access_token = config.get("ims_env", "personal_access_token")
api_base_url = config.get("ims_env", "api_base_url")

#Required if checkout_to_type is user
asset_id = "2687" #From Get_AssetDetails
status_id = 2 #From Get_StatusLabels #2 = ReadyToDeploy
user_id = 619 #From Get_MyUserDetails
user_note = "" #Optional

#API
url = api_base_url + "/hardware/" + asset_id + "/checkout"

payload = {
    "checkout_to_type": "user", 
    "status_id" : status_id ,
    "assigned_user" : user_id ,
    "note" : user_note 
}

headers = {
    "accept": "application/json",
    "Authorization": "Bearer " + personal_access_token,
    "content-type": "application/json"
}

response = requests.post(url, json=payload, headers=headers)

#Parse JSON from response.text
data = json.loads(response.text)

#Pretty Print JSON
json_formatted_str = json.dumps(data, indent=2)
print(json_formatted_str)