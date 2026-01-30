#!/bin/sh
#
# Host is SAMA7D65 Curiosity
#

echo "Host setup start...."
ip link set dev eth1 up
modprobe "8021q"
echo "Setting ip 192.168.10.1/24 to eth1 VLAN 10..."
ip link add link eth1 name vlan.10 type vlan id 10
ip add add 192.168.10.1/24 dev vlan.10
ip link set dev vlan.10 type vlan egress 0:0 # All SO_PRIORITY = 0 to PCP 0
ip link set dev vlan.10 up

echo "Setting ip 192.168.20.1/24 to eth1 VLAN 20..."
ip link add link eth1 name vlan.20 type vlan id 20
ip add add 192.168.20.1/24 dev vlan.20
ip link set dev vlan.20 type vlan egress 0:0 # All SO_PRIORITY = 0 to PCP 0
ip link set dev vlan.20 up

echo "Host setup done...."
