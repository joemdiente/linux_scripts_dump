#
# Get User ID Using Username
# Arguments:
#   1: User Search Term. Exact Results eg. Found '1'.
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
    search_username = sys.argv[1]
    url = api_base_url + "/users?search=" + search_username + "&limit=1&offset=0&sort=created_at&order=desc&deleted=false&all=false"

    headers = {
        "accept": "application/json" ,
        "Authorization": "Bearer " + personal_access_token
    }

    response = requests.get(url, headers=headers)

    #Parse JSON from response.text
    data = json.loads(response.text)

    #Pretty Print JSON
    json_formatted_str = json.dumps(data, indent=2)

    if data["total"] == 0:
        print("None Returned")
    elif data["total"] > 1:
        print("No Exact Match")
    else:
        #Output to stdout
        print(json_formatted_str)

        #
        #ID is the number found in the URL which is unique to the system
        #
        print("Debug: ID",data["rows"][0]["id"],":",data["rows"][0]["name"])

main()