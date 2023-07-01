



#ifndef IMS_API_H // include guard
#define IMS_API_H

#include <string>


class ims_api
{
    private:
        std::string token;
        std::string url_base;

    public:
        ims_api(const std::string t = "", 
            const std::string url = "");
        std::string get_userdetails(void);
};


#endif /* IMS_API_H */
