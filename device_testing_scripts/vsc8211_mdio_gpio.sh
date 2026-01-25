#!/bin/bash
PHYADD="0"     # Change to your PHY address

# MII Registers
for PHYREG in {0..31}; do
    printf "MII Standard Register 0x%02X: " $PHYREG
    mdio gpio-2 $PHYADD $PHYREG
done

mdio gpio-2 $PHYADD 31 1

for PHYREG in {16..31}; do
    printf "MII Extended Register 0x%02X: " $PHYREG
    mdio gpio-2 $PHYADD $PHYREG
done

echo "Done."