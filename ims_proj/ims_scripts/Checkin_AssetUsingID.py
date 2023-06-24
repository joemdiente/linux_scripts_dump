# 
# Checkin Asset using Asset ID
# Arguments:
#   1: AssetID : What item to check in
#   2: StatusID : Sets status of Asset. Use Status Labels First to find status ID.
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

    #User Required
    asset_id = sys.argv[1] #Asset ID (Debug: 2687)
    status_id = sys.argv[2] #Status ID

    #API
    url = api_base_url + "/hardware/" + asset_id + "/checkin"

    payload = {
        "status_id": status_id,
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