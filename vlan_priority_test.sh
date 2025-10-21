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

server_eth=enxf8e43bedf19d
client_eth=eth0

if [ "$#" -eq 0 ];
    then
        echo "Status: No arguments. Try \"help\"."
        exit 1
fi

#===Help
if [ "$1" = "help" ];
    then
        echo " Usage: "
        echo "  Always run as sudo. "
        echo "  First argument = server or client"
        echo "  Just check source code of this script (˶ˆᗜˆ˵) (≧ᗜ≦) 🤪"
        exit 1
fi

# Sanity Check Before Doing Anything
if [ ! -f ./vlan.sh ];
    then
        echo " Make sure to run where ./vlan.sh is found!"
        exit 1
fi

# server
if [ "$1" = "server" ];
    then
        echo " Setting up server:"
        sudo ./vlan.sh init
        sleep 1
        echo " Setting up VLAN 10."
        sudo ./vlan.sh add $server_eth 10
        sudo ip add add 192.168.10.2/24 dev vlan.10
        sudo ip link set dev vlan.10 type vlan egress 0:1
        sudo ip link set dev vlan.10 up
        echo " Adding IP Done; Setting VLAN 10 with PRIO 1 Done."
        
        echo " Setting up VLAN 20."
        sudo ./vlan.sh add $server_eth 20
        sudo ip add add 192.168.20.2/24 dev vlan.20
        sudo ip link set dev vlan.20 type vlan egress 0:3
        sudo ip link set dev vlan.20 up
        echo " Adding IP Done; Setting VLAN 20 with PRIO 3 Done."

        echo " Setting up VLAN 30."
        sudo ./vlan.sh add $server_eth 30
        sudo ip add add 192.168.30.2/24 dev vlan.30
        sudo ip link set dev vlan.30 type vlan egress 0:5
        sudo ip link set dev vlan.30 up
        echo " Adding IP Done; Setting VLAN 30 with PRIO 5 Done."
        exit 1
fi

# client
if [ "$1" = "client" ];
    then
        echo " Setting up client:"
        sudo ./vlan.sh init
        sleep 1
        echo " Setting up VLAN 10."
        sudo ./vlan.sh add $client_eth 10
        sudo ip add add 192.168.10.50/24 dev vlan.10
        sudo ip link set dev vlan.10 type vlan egress 0:1
        sudo ip link set dev vlan.10 up
        echo " Adding IP Done; Setting VLAN 10 with PRIO 1 Done."
        
        echo " Setting up VLAN 20."
        sudo ./vlan.sh add $client_eth 20
        sudo ip add add 192.168.20.50/24 dev vlan.20
        sudo ip link set dev vlan.20 type vlan egress 0:3
        sudo ip link set dev vlan.20 up
        echo " Adding IP Done; Setting VLAN 20 with PRIO 3 Done."

        echo " Setting up VLAN 30."
        sudo ./vlan.sh add $client_eth 30
        sudo ip add add 192.168.30.50/24 dev vlan.30
        sudo ip link set dev vlan.30 type vlan egress 0:5
        sudo ip link set dev vlan.30 up
        echo " Adding IP Done; Setting VLAN 30 with PRIO 5 Done."
        exit 1
fi

if [ "$1" = "iperf_client" ]
    then 
        echo " Now run # iperf3 -c 192.168.10.2 -B 192.168.10.50 -p 5210 -b 160k"
        echo " Now run # iperf3 -c 192.168.20.2 -B 192.168.20.50 -p 5220 -b 160k"
        echo " Now run # iperf3 -c 192.168.30.2 -B 192.168.30.50 -p 5230 -b 160k"
        exit 1
fi

if [ "$1" = "iperf_server" ]
    then 
        echo " Now run # iperf3 -s -B 192.168.10.2 -p 5210"
        echo " Now run # iperf3 -s -B 192.168.20.2 -p 5220"
        echo " Now run # iperf3 -s -B 192.168.30.2 -p 5230"
        exit 1
fi