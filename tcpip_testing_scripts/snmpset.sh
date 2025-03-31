#!/bin/sh

# snmpset -v2c -c private 192.168.137.116 VTSS-DNS-MIB::vtssDnsConfigServersSetting.1 i 1 VTSS-DNS-MIB::vtssDnsConfigServersStaticIpAddress.1 s "0.0.0.0" 
# # \
# # VTSS-DNS-MIB::vtssDnsConfigServersSetting.1 = INTEGER: static(1) \
# # VTSS-DNS-MIB::vtssDnsConfigServersStaticIpAddress.1 = STRING: 0.0.0.0

snmpset -v2c -c private 192.168.137.116 VTSS-IP-MIB::vtssIpConfigInterfacesIpv4Active.2 i 1 VTSS-IP-MIB::vtssIpConfigInterfacesIpv4PrefixSize.2 u 24 VTSS-IP-MIB::vtssIpConfigInterfacesIpv4EnableDhcpClient.2 i 1

