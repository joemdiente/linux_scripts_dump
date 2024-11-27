#!/bin/sh
IF=enxf8e43bedf19d

#Prepare Host for Multicast
#./igmp_linux_host_setup.sh $1 $2

#Test
# ./igmp_linux_host_setup.sh $IF 224.0.0.0/8

#IGMP Group Record Type
MODE_IS_INCLUDE=1
MODE_IS_EXCLUDE=2
CHANGE_TO_INCLUDE_MODE=3
CHANGE_TO_EXCLUDE_MODE=4 
ALLOW_NEW_SOURCES=5
BLOCK_OLD_SOURCES=6

#Source
SMAC="84:29:99:5B:3C:62" #Test MAC Address Only
SIP="192.168.137.1"

#Destination
DMAC_QUERY="01:00:5e:00:00:01"
DMAC_REPORT="01:00:5e:00:00:16"
DIP_QUERY=224.0.0.1             #General Query
DIP_LEAVE=224.0.0.2             #Leave Group
DIP_V3=224.0.0.22              
DIP_GROUP=239.255.255.250                      #Your desired multicast Group

#Source IP Address in Hex Delimited with ::::
SRCADD_IN_HEX=C0:A8:89:DE      #192.168.137.222

####### Main Code #########
# # Membership Join 
sudo ef tx enxf8e43bedf19d \
eth smac $SMAC dmac $DMAC_REPORT \
ipv4 sip $SIP dip $DIP_V3 ttl 1  \
igmp type 0x22 \
ng 1 \
igmpv3_group rec_type $MODE_IS_INCLUDE ns 1 ga $DIP_GROUP data hex $SRCADD_IN_HEX

# Membership Report / CHANGE_TO_EXCLUDE
# sudo ef tx enxf8e43bedf19d \
# eth smac $SMAC dmac $DMAC_REPORT \
# ipv4 sip $SIP dip $DIP_V3 ttl 1  \
# igmp type 0x22 \
# ng 1 \
# igmpv3_group rec_type $CHANGE_TO_EXCLUDE_MODE ns 1 ga $DIP_GROUP data hex $SRCADD_IN_HEX