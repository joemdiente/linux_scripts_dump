#!/bin/sh

IF=enxf8e43bedf19d

# Destination
DMAC_QUERY="01:00:5e:40:01:01"
DMAC_REPORT="01:00:5e:40:01:01"
DIP=239.192.001.001            


# Source
TEST_MAC1="84:29:99:5B:3C:62" #Test MAC Address Only (Apple)
TEST_MAC2=00:01:C1:00:00:02 #Test MAC (Vitesse)
SIP="198.019.001.002"

sudo ef tx $IF \
eth smac $TEST_MAC2 dmac $DMAC_REPORT \
ipv4 sip $SIP dip $DIP ttl 1 

