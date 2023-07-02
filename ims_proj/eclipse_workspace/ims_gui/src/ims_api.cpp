/*
 * ims_api.c - APIs to access Inventory Management System
 * 
 * Authored By: Joemel John A. Diente
 */


/* System Headers */
#include <cstdlib>
#include <string>
#include <iostream>

/* API Header */
#include "../include/ims_api.h"

// Default Constructor
ims_api::ims_api (const std::string t, const std::string url)
{
    token = t;
    url_base = url;
}

/* 
 * CUrl Write Callback to a variable
 * From: https://stackoverflow.com/questions/9786150/save-curl-content-result-into-a-string-in-c
 */
static size_t curl_wcb(void *contents, size_t size, size_t nmemb, void *userp)
{ 
    ((std::string*)userp)->append((char*)contents, size * nmemb);
    return size * nmemb;
}

/*
 * Get User Details of IMS API instance
 * Returns a Nlohmann JSON Object
 */
json ims_api::get_userdetails(void)
{
    std::string url_user_me = "/users/me";
    std::string header_auth_complete;
    std::string url_complete;
    std::string curl_response;
    json json_response;

    //Prepare Request
    url_complete = url_base + url_user_me;
    header_auth_complete = header_auth + token;

    //Prepare CURL
    CURL *curl_handle = curl_easy_init();
    curl_easy_setopt(curl_handle, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(curl_handle, CURLOPT_WRITEFUNCTION, curl_wcb);
    curl_easy_setopt(curl_handle, CURLOPT_WRITEDATA, &curl_response);
    curl_easy_setopt(curl_handle, CURLOPT_URL, url_complete.c_str());

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, header_json.c_str());
    headers = curl_slist_append(headers, header_auth_complete.c_str());
    curl_easy_setopt(curl_handle, CURLOPT_HTTPHEADER, headers);

    CURLcode ret = curl_easy_perform(curl_handle);

    if(curl_response.empty())
    {
        std::cout << "ERROR: No Response or Empty Response" << std::endl;
        //Nothing to Parse
        return json_response;
    }

    //Parse HTTP Response
	json_response = json::parse(curl_response);

    //Should only return required information TODO.
    return json_response;
}
