#!/bin/sh
IF=enxf8e43bb3bcec

echo "Make sure to run script as sudo else nothing will show below."
#enable icmp broadcast
sysctl net.ipv4.icmp_echo_ignore_broadcasts
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0
sysctl net.ipv4.icmp_echo_ignore_broadcasts

ip route add 232.0.0.0/8 dev $IF
#Join to multicast address
# ip addr add 232.100.100.50/24 dev $IF autojoin
# echo "Verify Below"
# ip -f inet maddr show dev $IF