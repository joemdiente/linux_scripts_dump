#!/bin/sh

# Rebuild script
make host-uboot-tools-rebuild && make linux-rebuild && make dt-overlay-mchp-rebuild && make
# balena local flash ./images/sdcard.img --drive /dev/sdb -y

# local interface = link partner
# remote interface = DUT LAN8720

# Local Interface
sudo ethtool -s enx34298f7001a5 autoneg off speed 10 duplex full
sudo ethtool enx34298f7001a5

# Remote Interface
ethtool -s eth0 autoneg off speed 10 duplex full

## registers
    # 0x00 0x4100 
    # 0x1b 0x8000
    # 0x11 0x0200
    # 0x00 0x4100
## mdio-tools

echo "phy dump"
for x in {0..31..1}
do
    echo "PHYREG[$x]"
    mdio f* phy 0 raw $x
done
mdio f* phy 0 raw 0x00 0x4900
mdio f* phy 0 raw 0x1b 0x8000
mdio f* phy 0 raw 0x11 0x0200
mdio f* phy 0 raw 0x00 0x4500
mdio f* phy 0 raw 0x00
mdio f* phy 0 raw 0x1b
mdio f* phy 0 raw 0x11

mdio f* phy 0 raw 0x11 0x0000
## phytool
