import requests

#PTC-IMS
personal_access_token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI4IiwianRpIjoiNTYzYzU4MWRjY2I2YWE3YTc2MmFhMDZjZTllNWFhNTJhYWFlMzk0NWIwOTExN2JmMTRmODAxYzRjZDkyZmFmZWQ4ZjhmYmQ2NDdiMGE0N2YiLCJpYXQiOjE2NzM1ODQ0MTAuMTg4NDc4LCJuYmYiOjE2NzM1ODQ0MTAuMTg4NDg0LCJleHAiOjIxNDY5NzAwMTAuMTc5Mjg0LCJzdWIiOiI2MTkiLCJzY29wZXMiOltdfQ.dCPhIMcWrAM6QFIvzfFBSG2z8k33cMZCilvXG2nshRaI1PJX1NlWKebAF2mAlkjq6vBmyQAJkgiEmVwk9VBbH-KlBx1CTbw7upyx2GxogcWc_zBfvpRRefm8bB3xIq5CG-IMRHyRmcpItXRmZphkTf-YSFEZl6YzyBn8MjtouYXm_YPPpZkD3f_QrQZf-2yP-19Ox0Y8irlAYxWHwV5YSO5LOobZmxxYjhz0MGrpOzrjRs-JaTPOvYJmn4hC-mwZ9noQIKx-wScWjJl4sX6IKBiptfjxjx-MRmtPPMg5FzLhRfO85a2Xe-FhofubSZs0kJY_YHIJZ1h6Cwm77pnNzh6VP6YlWxay2ls9ZCdUMCfYFAJqrE71eJVBmiZpyMbuyazmhFNZojSp7bsLSjYOkDCZOf0cRlgyWQWVz8fRj2_PmOCIuuX8D_ulEPkDW-E1ni8cxtFWLNYJghs5xZ6dUbi_j967ht1MfutV-ghnTA1krxrfN95y5Cmn2K8UwmUVBZBzlCAEBbBEQVEAZnFdodV7Ve3A1LvnHZug-yZi2HEWU2V-KREbajDgtV4U67GB-hFT67ErTxEozVOQ8jKylDe28brb2hroCECQKGBsAfmxZCigNWN7fXunZ4adcjL2HeKyQ-C3aNEuyghjGhfPsJ3eNhqZ3qVjVfW5ph0Mvig"
api_base_url = "http://ptc-vm-caeims/api/v1"

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

import json

#Parse JSON from response.text
data = json.loads(response.text)

#Pretty Print JSON
json_formatted_str = json.dumps(data, indent=2)
print(json_formatted_str)