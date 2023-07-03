#include <iostream>
#include <memory>

#include <egt/ui>
#include <egt/uiloader.h>

#include <cstdlib>

/**
 * Nlohmann JSON
 * GitHub: https://github.com/nlohmann/json
 * Available in Buildroot
 *
*/
#include <nlohmann/json.hpp>
using json = nlohmann::json;
#define DEBUG_JSON() std::cout << j.dump(4) << std::endl

/**
 * OpenCV3
 * 
*/
#include <opencv2/objdetect.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <iostream>
 
using namespace cv;
using namespace std;
/**
 * Inventory Management API Header
 * 
 */
#include "include/ims_api.h"
/*
 * main program
 */
int main(int argc, char** argv)
{
    egt::Application app(argc, argv);

    egt::experimental::UiLoader loader;
    auto window = std::static_pointer_cast<egt::Window>(loader.load("file:ui.xml"));

    std::cout << "start test" << std::endl;

    auto label = window->find_child<egt::Label>("userdata-1");

	auto button = window->find_child<egt::Button>("find-user-1");

	auto frame = window->find_child<egt::Button>("frame-1");
	//Start of Test

	//Use ims_api test
	std::string test_url = "http://127.0.0.1:8080/api/v1";
    std::string test_token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxMCIsImp0aSI6IjM3Y2NmZTZiMjZmNGE0OTE0ODhiM2Q1NmViYzVlYzA4YTAxNGM5MDZhMTBkM2EyZjUyMWVmZmE5ODM0MTE2MTkwNTk1NWVkZWJkZmJmYTE2IiwiaWF0IjoxNjg4MzA4MTE5Ljg5OTkxOCwibmJmIjoxNjg4MzA4MTE5Ljg5OTkyMSwiZXhwIjoyMzE5NDYzNzE5Ljg5NDA0OSwic3ViIjoiMjEzIiwic2NvcGVzIjpbXX0.EkmZ1nn0OkSKPkLx5Uqdh5-TXwXciq3n2EP-MM_rFOrYKUd4-fhFG2WO5rwhrzS4VTQt5iN4kDpPowlu3ihIJ4KeQH2wo5b_HBomvmjVaPXfpm0kyJi1qlgV5eyt_4_VrtVwZKO9B4URyprsEaBL8QL0WX_Js-wa2VNO345L6oYiMaU6upqlO8zC5DIPHIRR_AGON5fRpIt_946lNZ0Zj9ipydNBrlI2FHSJCYTIH8qsi2Ea39h8WUovAKApqwJoMvtIYP8Cm6cxDqOC4GpKBz_7C7yW2bQtcf21WG6HeV9qMXJCSjFvUN1HwDJRbjlMTFFkUUG7ah0SzbpXiAX8_qEymva6Rb_lPgnRPOu8eMvJAUKPnuBPhdg9gYOPyFpk9_pAVAjaAYyNhf_bTIqF0ARgGYHkPfMY3rJ8ErDFE694dJWnMzFK-HveJ5RTYd10DeeQyWB4aHVcgMqJdgZQSgSvyok4UqouB8x5Wys9RuMqflxopPnH6BUa1DxcmOd9JGqaKpzfxKrbe12vSPkYA-n778Yco6RdgmDBOgRHhBM0M8f2F6BjjLu6KiOe0vEztnkgk8ZpZCPhEpgiPnHUSZkFfHwoy4_OFepwDpTDjn2XKlyVebbGS6-cMkNGjQUnI-YxAnUqIaaY0ACIitLVrBB9_bZqKK1kQxks3l0uv_U";

	ims_api ims_api_instance(test_token, test_url);
	
	button->on_click([&label, &ims_api_instance](egt::Event&)
	{
		if (label->visible())
		{
			
			//Get User Details 
			nlohmann::json j =ims_api_instance.get_userdetails();
			j.dump(4);
			DEBUG_JSON();
			
			//Format User Information
			std::stringstream user_information;
			user_information << \
				"ID: " << j["id"] << " Badge: " << j["username"] << std::endl <<\
				"E-Mail: " << j["email"] << std::endl <<\
			std::endl;

			label->text(user_information.str());	
			label->default_text_align();		
		}
		else
			label->visible(true);

	});

	

    window->show();
    return app.run();
}

//Use Camera
//Take a picture of API key in QR CODE
//Take that to OpenCV in Python
//Return API key to this code.
