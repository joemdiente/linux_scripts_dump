cmake_minimum_required(VERSION 3.10)

# set the project name and version
project(my_test_hid_app VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# configure a header file to pass some of the CMake settings
# to the source code 
configure_file(my_test_hid_app.h.in my_test_hid_app.h)

# add the executable
add_executable(Test_HID_App my_test_hid_app.c)