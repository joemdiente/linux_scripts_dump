



#ifndef IMS_API_H // include guard
#define IMS_API_H

#include <string>

/* External Libraries */
#include <curl/curl.h>
#include <nlohmann/json.hpp>
using json = nlohmann::json;

class ims_api
{
    private:
        //Access Information
        std::string token;
        std::string url_base;

        //HTTP Request
        std::string header_json = "accept: application/json";
        std::string header_auth = "Authorization: Bearer ";

    public:
        ims_api(const std::string t = "", 
            const std::string url = "");
        json get_userdetails(void);
};


#endif /* IMS_API_H */
