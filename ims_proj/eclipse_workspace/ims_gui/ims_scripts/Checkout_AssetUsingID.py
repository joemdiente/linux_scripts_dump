# 
# Checkout Asset using Asset ID
# Arguments: 
#   1: AssetID : Unique ID of Asset
#   2: StatusID : Sets Status to:
#   3: UserID : Unique ID of User (Checkout to:)
#   4: Notes : Not Optional
# Authored by: Joemel John A Diente 

import json
import requests
import configparser
import sys

def main():

    #Get details from api.cfg
    config = configparser.ConfigParser()
    config.read("api.cfg")

    personal_access_token = config.get("ims_env", "personal_access_token")
    api_base_url = config.get("ims_env", "api_base_url")

    #Required if checkout_to_type is user
    asset_id = sys.argv[1] 
    status_id = sys.argv[2]
    user_id = sys.argv[3]
    user_note = sys.argv[4]    

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

main()