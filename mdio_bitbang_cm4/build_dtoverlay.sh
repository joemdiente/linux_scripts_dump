#!/bin/sh

echo "[Script Prompt] Running DTC...."
sudo dtc -@ -I dts -O dtb -o mdio-gpio-cm4.dtbo mdio_gpio_cm4.dtso
echo "[Script Prompt] Copying mdio-gpio-cm4.dtbo to /boot/overlays ..."
sudo rsync -vrP ./mdio-gpio-cm4.dtbo /boot/overlays
echo "[Script Prompt] Finished!"
echo "[Script Prompt] ======================================================="
echo "[Script Prompt] Make sure to add \"dtoverlay=mdio-gpio-cm4\" to /boot/firmware/config.txt (in CM4) then REBOOT"
echo "[Script Prompt] Tip: Line can be added under [cm4] or [all]...."
echo "[Script Prompt] ======================================================+"