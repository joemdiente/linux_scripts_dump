#!/bin/sh
SWITCHIP=192.168.137.22

### Step 2:
snmpwalk -v2c -c private $SWITCHIP VTSS-IP-MIB::vtssIpConfigInterfacesIpv4Active 
snmpwalk -v2c -c private $SWITCHIP VTSS-IP-MIB::vtssIpConfigInterfacesIpv4EnableDhcpClient
snmpwalk -v2c -c private $SWITCHIP VTSS-IP-MIB::vtssIpConfigInterfacesIpv4Ipv4Address
snmpwalk -v2c -c private $SWITCHIP VTSS-IP-MIB::vtssIpConfigInterfacesIpv4PrefixSize

### Step 3:
snmpset -v2c -c private $SWITCHIP VTSS-IP-MIB::vtssIpConfigInterfacesIpv4Active.2 i 1 \
VTSS-IP-MIB::vtssIpConfigInterfacesIpv4PrefixSize.2 u 24 \
VTSS-IP-MIB::vtssIpConfigInterfacesIpv4DhcpClientFallbackTimeout.2 u 0 \
VTSS-IP-MIB::vtssIpConfigInterfacesIpv4EnableDhcpClient.2 i 1

### Step 4:
snmpwalk -v2c -c private $SWITCHIP VTSS-IP-MIB::vtssIpConfigInterfacesIpv4Active 
snmpwalk -v2c -c private $SWITCHIP VTSS-IP-MIB::vtssIpConfigInterfacesIpv4EnableDhcpClient
snmpwalk -v2c -c private $SWITCHIP VTSS-IP-MIB::vtssIpConfigInterfacesIpv4Ipv4Address
snmpwalk -v2c -c private $SWITCHIP VTSS-IP-MIB::vtssIpConfigInterfacesIpv4PrefixSize