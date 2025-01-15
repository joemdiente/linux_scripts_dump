# MDIO Bitbang Experimenting in RPI CM4

**Links**

mdio-gpio
https://www.kernel.org/doc/Documentation/devicetree/bindings/net/mdio-gpio.txt
https://github.com/torvalds/linux/blob/master/drivers/net/mdio/mdio-gpio.c

loading dtoverlays on rpi
https://forums.raspberrypi.com/viewtopic.php?t=330088

decompile current device-tree 
dtc -I fs -O dts /sys/firmware/devicetree/base > current.dts
