#
# Get Asset ID using Asset Tag
# Arguments:
#   1: Asset Tag (PHxxxx)
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

    #API
    url = api_base_url + "/hardware/bytag/" + sys.argv[1] + "?deleted=false"

    headers = {
        "accept": "application/json",
        "Authorization": "Bearer " + personal_access_token
    }

    response = requests.get(url, headers=headers)

    #Parse JSON from response.text
    data = json.loads(response.text)

    #Pretty Print JSON
    json_formatted_str = json.dumps(data, indent=2)
    print(json_formatted_str)

    #ID is the number found in the URL, which is also found in QR codes
    print("Debug: ID",data["id"],"Serial: ",data["serial"],"Asset Name: ",data["model"]["name"])

main()