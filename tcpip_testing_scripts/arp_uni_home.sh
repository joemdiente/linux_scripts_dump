# This sends a request from 
# the dongle
# to ask the switch 
#
sudo ef tx enx34298f7001a5 \
eth dmac 00:01:C1:78:73:57 smac f8:e4:3b:ed:f1:9d \
arp oper 1 ptype 0x0800 \
sha f8:e4:3b:ed:f1:9d spa 192.168.137.2 \
tha 20:e8:74:11:33:77 tpa 192.168.137.15

#example mod acl arp smac 00:01:C1:78:73:57 spa 192.168.137.15 tha 192.168.137.2
