#include <cxxopts.hpp>
#include <egt/ui>
#include <egt/uiloader.h>
#include <iostream>

/*
 * main Function
 */
int main(int argc, char** argv)
{
	std::cout << "Start of Program" << std::endl;

    egt::Application app(argc, argv);
#ifdef EXAMPLEDATA
    egt::add_search_path(EXAMPLEDATA);
#endif

    cxxopts::Options options(argv[0], "load ui xml");
    options.add_options()
    ("h,help", "Show help")
    ("i,input", "Input file", cxxopts::value<std::string>()->default_value("file:ui.xml"));
    auto args = options.parse(argc, argv);
    if (args.count("help"))
    {
        std::cout << options.help() << std::endl;
        return 0;
    }

    egt::experimental::UiLoader loader;
    auto window = loader.load(args["input"].as<std::string>());

//    window->on_show([&]()
//    {
//        for (const auto& w : app.windows())
//        {
//#ifdef EGT_HAS_VIDEO
//            if (w->type() == "VideoWindow")
//            {
//                egt::VideoWindow* vwin = dynamic_cast<egt::VideoWindow*>(w);
//                vwin->play();
//            }
//#endif
//#ifdef EGT_HAS_CAMERA
//            if (w->type() == "CameraWindow")
//            {
//                egt::CameraWindow* cwin = dynamic_cast<egt::CameraWindow*>(w);
//                cwin->start();
//            }
//#endif
//        }
//    });

    window->show();
    return app.run();
}
