#!/bin/sh

echo "[Script Prompt] Cleaning up previous build...."
echo "[Script Prompt] Make sure you are running this script on Raspberry Pi CM4"
echo "[Script Prompt] TODO: Check if /proc/device-tree/model contains \"Raspberry Pi\""
sudo rm -rf ./*.dtbo
echo "[Script Prompt] Running DTC...."
sudo dtc -@ -I dts -O dtb -o mdio-gpio-cm4.dtbo mdio-gpio-cm4.dtso
sudo dtc -@ -I dts -O dtb -o spi1-3cs-overlay-test.dtbo spi1-3cs-overlay-test.dtso #For testing only
echo "[Script Prompt] Copying *.dtbo to /boot/overlays and /boot/firmware/overlays ..."
sudo rsync -vrP ./*.dtbo /boot/overlays
sudo rsync -vrP ./*.dtbo /boot/firmware/overlays
echo "[Script Prompt] Finished!"
echo "[Script Prompt] ======================================================="
echo "[Script Prompt] Make sure to add \"dtoverlay=mdio-gpio-cm4\" to /boot/firmware/config.txt (in all) then REBOOT"
echo "[Script Prompt] Tip: Line can be added under [cm4] or [all]...."
echo "[Script Prompt] ======================================================+"