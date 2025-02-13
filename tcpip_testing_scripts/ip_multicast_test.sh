#!/bin/sh

IF=enxf8e43bedf19d

# Destination
DMAC_QUERY="01:00:5e:00:00:01"
DMAC_REPORT="01:00:5e:00:00:16"
DIP_QUERY=224.0.0.1             #General Query
DIP_LEAVE=224.0.0.2             #Leave Group
DIP_V3=224.0.0.22              
DIP_GROUP=239.255.255.250  

# Source
TEST_MAC1="84:29:99:5B:3C:62" #Test MAC Address Only (Apple)
TEST_MAC2=00:01:C1:00:00:02 #Test MAC (Vitesse)
SIP="192.168.137.1"

sudo ef tx $IF \
eth smac $TEST_MAC2 dmac $DMAC_REPORT \
ipv4 sip $SIP dip $DIP_V3 ttl 1 