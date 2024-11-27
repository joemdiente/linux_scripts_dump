#!/bin/sh
IF=$1     #enxf8e43bedf19d
MC_ADD=$2 #232.0.0.0/8

sudo echo "Make sure to run script as sudo else nothing will show below."
sudo echo "Network Interface for Multicast: $1"

#enable icmp broadcast
sudo sysctl net.ipv4.icmp_echo_ignore_broadcasts
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0
sudo sysctl net.ipv4.icmp_echo_ignore_broadcasts

# Make sure to add a route so multicast are routed properly.
echo "sudo ip route add $MC_ADD dev $IF - command"
sudo ip route add $MC_ADD dev $IF

# Join to multicast address
# ip addr add 232.100.100.50/24 dev $IF autojoin
# echo "Verify Below"
# ip -f inet maddr show dev $IF