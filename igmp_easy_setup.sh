#!/bin/sh
IF=enxf8e43bb3bcec

echo "Make sure to run script as sudo else nothing will show below."
#enable icmp broadcast
sysctl net.ipv4.icmp_echo_ignore_broadcasts
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0
sysctl net.ipv4.icmp_echo_ignore_broadcasts
#Join to multicast address
ip addr add 232.0.1.50/24 dev $IF autojoin
echo "Verify Below"
ip -f inet maddr show dev $IF