#!/bin/sh

#
# Client is Test-PC 2
#

echo "Client setup start...."

sudo modprobe 8021q 
echo "Setting ip 192.168.10.10/24 to lan7430-1 VLAN 10..."
sudo ip link add link lan7430-1 name vlan.10 type vlan id 10
sudo ip add add 192.168.10.10/24 dev vlan.10
sudo ip link set dev vlan.10 type vlan egress 0:1 # All SO_PRIORITY = 0 to PCP 1
sudo ip link set dev vlan.10 up
sudo ethtool -K lan7430-2 lro off
sudo ethtool -K lan7430-2 gro off

# VM
sudo modprobe 8021q 
echo "Setting ip 192.168.20.20/24 to enp0s3 VLAN 20..."
sudo ip link add link enp0s3 name vlan.20 type vlan id 20
sudo ip add add 192.168.20.20/24 dev vlan.20
sudo ip link set dev vlan.20 type vlan egress 0:7 # All SO_PRIORITY = 0 to PCP 7
sudo ip link set dev vlan.20 up

echo "Client setup done...."
