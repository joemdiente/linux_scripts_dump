# IMS_GUI

This is main code for IMS GUI.

## How to Build in Host:
- sudo apt-get install nlohmann-json3-dev curl
-- make (Builds main executable)
-- make test (Builds and then runs executable)
-- make unzip (unzips ui.zip if ui.xml not found error)

## How to Build for Target (SAMA5D4-Xplained-Ultra)
- use Eclipse CDT (see <ims_proj>/eclipse_workspace/README.md)