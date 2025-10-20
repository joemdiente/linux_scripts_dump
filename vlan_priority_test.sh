#!/bin/sh
# Example in testing VLAN priority test
#
# Written by: Joemel John A. Diente <joemdiente@gmail.com>
# 

# Server (Laptop) <--> KSZ8864 <--> Client (RPI)
# iperf3 server <------------------> iperf3 client
# 192.168.10.2  <----- VLAN 10 ----> 192.168.10.50 
                    # PRIO 5 DEI 0
# 192.168.20.2  <----- VLAN 20 ----> 192.168.20.50
                    # PRIO 0 DEI 0

server_eth="enxf8e43bedf19d"
client_eth="eth0"

if [ ! -f ./vlan.sh ];
    then
        echo " Make sure to run where ./vlan.sh is found!"
fi

# server
if [ "$1" = "server" ];
    then
        echo " Setting up server:"
        sudo ./vlan.sh init
        sleep 1
        echo " Setting up VLAN 10."
        sudo ./vlan.sh add "$server_eth" 10
        sudo ip add add 192.168.10.2/24 dev $server_eth
        sudo ip link set dev vlan.10 type vlan egress 0:5
        echo " Adding IP Done; Setting VLAN 10 with PRIO 5 Done."
        
        echo " Setting up VLAN 20."
        sudo ./vlan.sh add "$server_eth" 20
        sudo ip add add 192.168.20.2/24 dev $server_eth
        echo " Adding IP Done; Setting VLAN 10 with PRIO 0 Done."
        echo " Now run # iperf -s -B 192.168.10.2 -p 5210"
        echo " Now run # iperf -s -B 192.168.20.2 -p 5220"
fi

# client
if [ "$1" = "client" ];
    then
        echo " Setting up client:"
        sudo ./vlan.sh init
        sleep 1
        echo " Setting up VLAN 10."
        sudo ./vlan.sh add $client_eth 10
        sudo ip add add 192.168.10.50/24 dev $client_eth
        sudo ip link set dev vlan.10 type vlan egress 0:5
        echo " Adding IP Done; Setting VLAN 10 with PRIO 5 Done."
        
        echo " Setting up VLAN 20."
        sudo ./vlan.sh add $client_eth 20
        sudo ip add add 192.168.20.50/24 dev $client_eth
        echo " Adding IP Done; Setting VLAN 10 with PRIO 0 Done."
        echo " Now run # iperf -c 192.168.10.2 -B 192.168.10.50 -p 5210"
        echo " Now run # iperf -c 192.168.20.2 -B 192.168.20.50 -p 5220"
fi
