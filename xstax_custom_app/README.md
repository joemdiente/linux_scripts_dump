# This is my example in adding my custom C app in IStaX image.

Creating my own C app for an ARM64 LAN9696 switch

1. Make sure to use the same toolchain /opt/mscc/mscc-toolchain**/-gcc \
    >To find gcc use, \
    >**find /opt/mscc/mscc-toolchain-bin-2024.02.6-108/ -name "*gcc"**. \
    >Use the correct GCC for your architecture. 
    >In 2024.12 and LAN9696, 
    >**/opt/mscc/mscc-toolchain-bin-2024.02.6-108/arm64-armv8_a-linux-gnu/bin/aarch64-armv8_a-linux-gnu-gcc**
2. Build example C app.
3. To test if working, upload the example app to /tmp 
    > From IStaX CLI: \
    > \# platform debug allow \
    > \# debug system shell \
    > ~ # cd /tmp \
    > ~ # tftp -g -r example -l example 192.168.137.2 \
    > /tmp # ls \
    > example           ospf6d.conf       staticd.log       zebra.pid \
    > fw_printenv.lock  ospfd.conf        staticd.pid       zebra.socket \
    > hiawatha          resolv.conf       staticd.vty       zebra.vty \
    > json.socket       ripd.conf         switch_app.ready \
    > mmcblk0p5         staticd.conf      zebra.log \
    > /tmp # chmod 775 example \
    > /tmp # ./example \
    > File 'hello_world.txt' created successfully!


Append to image (ARM VSC and LAN96xx chips)

sudo ln -s ~/linux_scripts_dump/xstax_custom_app/fsoverlay ~/vsc_sdk/IStaX-APPL-2024.12/src/build/