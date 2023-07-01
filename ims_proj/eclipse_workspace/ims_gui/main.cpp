#include <iostream>
#include <memory>

#include <egt/ui>
#include <egt/uiloader.h>

#include <cstdlib>

// Inventory Management API Header
#include "include/ims_api.h"

/*
 * main program
 */
int main(int argc, char** argv)
{
    egt::Application app(argc, argv);

    egt::experimental::UiLoader loader;
    auto window = std::static_pointer_cast<egt::Window>(loader.load("file:ui.xml"));

    std::cout << "test" << std::endl;

    std::string url = "http://127.0.0.1:8080/api/v1";
    std::string tok = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxMCIsImp0aSI6IjUwZDU4MjYxN2Y3YjcxMGMxZmJhZmM4MDdkMGM1YjVkMGQyOGNiN2Q5YzYyYzNjMDQzNTFkZjljYmIzMDAwZTFhZGI2NGI3Njc0N2M0MDg4IiwiaWF0IjoxNjg3NjAxOTgzLjYwNzY2NSwibmJmIjoxNjg3NjAxOTgzLjYwNzY2OSwiZXhwIjoyMzE4NzU3NTgzLjU3Mzk1OSwic3ViIjoiMSIsInNjb3BlcyI6W119.snGBAFndn_J2XXC34js3A_yy5ZsEih7EpGgcCs3NKwVymrOB-ID3LbJnhQdxE2orNLtDRI8fyPEPSLKE9yAbT5E9ZV7vxcKjp4Jl_Ca8d4j30QbyZugU6errE3xZApVp6lddlxdxBUBREh_7_TV80zsy0Lp3BxCpHCPavAYukv4_7uE54nzC_vFAYDp-sqQcFhW6fIL-nUaoZoHZCsF0j0zWkvNxg0NX9ZZ1TmnsukS2r6fuliU85pkLMaxm6xD9XpFl0j6YdU_4jaxN-hQjz26pWm6RMh1NmBKC1xd8exW8q78huqCTqouqbIXAJDkLEZRXW5461hRHhklcWjB8WEoN8CIAzeGcqiw4QCL1FmBDCbSqmrMUpD7pIY6p4roDMzZDl1rWJ_L7JYDOGdMwnVLUdJG09Wfsj6it7t-6MEGl-Aj5Ld43cPH9IDJZ59H2WsVeOj3kHdM_3263AZlo4cNap7zR_AC0p_n8NeukihQh-oL8DzLYMLei9dntIBZxzJJsc4oS4JzpdLIey49-ajVzD1WHvFHlimBPFDvGVYPr0nceKIb4rLO0SHZei7DXrFwzxET0khoCPi0-CHSn1VAFmMf-4y1cR6njdqof1O9nf_DGpQkZsbZZsIc6vD7-aDjlToq9z7YciMTNxoZkg-kfIN13O8TeDB9YHLPmP34";

	ims_api api1(tok, url);
	api1.get_userdetails();
	return  0;

    auto label = window->find_child<egt::Label>("userdata-1");

	auto button = window->find_child<egt::Button>("ok-1");

	button->on_click([&label](egt::Event&)
	{
		if (label->visible())
		{
			
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
