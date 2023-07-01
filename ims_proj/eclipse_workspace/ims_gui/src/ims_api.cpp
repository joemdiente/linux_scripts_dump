/*
 * ims_api.c - APIs to access Inventory Management System
 * 
 * Authored By: Joemel John A. Diente
 */


/* System Headers */
#include <cstdlib>
#include <string>
#include <iostream>

/* External Libraries */
#include <curl/curl.h>
#include <nlohmann/json.hpp>

/* API Header */
#include "../include/ims_api.h"
std::string header_json = "accept: application/json";
std::string header_auth = "Authorization: Bearer ";

// Default Constructor
ims_api::ims_api (const std::string t, const std::string url)
{
    token = t;
    url_base = url;
}

std::string ims_api::get_userdetails(void)
{
    std::string url_user_me = "/users/me";
    std::string header_auth_complete;
    std::string url_complete;

    //Prepare Request
    url_complete = url_base + url_user_me;
    header_auth_complete = header_auth + token;

    //Test Only
    std::string json_response = "test_resp";
    std::cout << header_auth_complete << std::endl;
    std::cout << url_complete << std::endl;

    //Prepare CURL
    CURL *hnd = curl_easy_init();
    curl_easy_setopt(hnd, CURLOPT_CUSTOMREQUEST, "GET");
    curl_easy_setopt(hnd, CURLOPT_WRITEDATA, stdout);
    curl_easy_setopt(hnd, CURLOPT_URL, url_complete.c_str());

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, header_json.c_str());
    headers = curl_slist_append(headers, header_auth_complete.c_str());
    curl_easy_setopt(hnd, CURLOPT_HTTPHEADER, headers);

    CURLcode ret = curl_easy_perform(hnd);
    return json_response;
}
