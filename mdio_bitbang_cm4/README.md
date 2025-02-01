# MDIO Bitbang Experimenting in RPI CM4

## **Maybe Useful Links**

    mdio-gpio
    https://www.kernel.org/doc/Documentation/devicetree/bindings/net/mdio-gpio.txt
    https://github.com/torvalds/linux/blob/master/drivers/net/mdio/mdio-gpio.c

    loading dtoverlays on rpi
    https://forums.raspberrypi.com/viewtopic.php?t=330088

    spi1-3cs-overlay-test.dtso is used just for testing if my process for setting up overlay works

    decompile current device-tree 
    dtc -I fs -O dts /sys/firmware/devicetree/base > current.dts

## mdio-tools install guide:
    1. git clone https://github.com/wkz/mdio-tools
    2. cd mdio-tools
    3. cd kernel/
    4. make all && sudo make install
    5. (if skipping BTF generation message): sudo apt-get install dwarves
    6. (skip this step if not): make all && sudo make install
    7. cd ../
    8. ./autogen.sh
    9. sudo apt-get install libmnl-dev
    10. ./configure --prefix=/usr && make all && sudo make install