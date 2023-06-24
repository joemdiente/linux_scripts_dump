#!/bin/sh
#
# Script to set my lan dongle to 192.168.137.1/24
#
sudo ip ad flush dev enx34298f7001a5
sudo ip ad ad 192.168.137.1/24 dev enx34298f7001a5