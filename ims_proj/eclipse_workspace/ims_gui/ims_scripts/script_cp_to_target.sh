#!/bin/sh
#
# Transfer .py .xml and .cfg to target 192.168.137.101 root dir
#
unzip -o ./ui.zip
scp -r ./* root@192.168.137.101:/root

