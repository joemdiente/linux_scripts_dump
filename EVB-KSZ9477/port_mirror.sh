#!/bin/sh
#Port Mirroring Script
#Written By: Joemel John A. Diente <joemdiente@gmail.com>

#Variables
max_port=6
i=0

#====Change Directory
cd /sys/class/net/eth0

#====Check Arguments
if [ "$#" -eq 0 ];
then
        echo " Error: No Arguments Passed. Check '/help'"
        exit 1
fi

#====Help
if [ "$1" == "/help" ];
then
    echo "  Usage:"
    echo "          mirror = set as mirror port (rx & tx)"
    echo "          sniffer = set as sniffer port"
    echo "          mirror off or sniffer off = disables all mirror/sniffer ports"
    echo "  Example:"
    echo "          ./port_mirror.sh [mirror/sniffer] [port number/'off']"
    exit 1
fi

#====Main
if [ "$1" == "mirror" ];
then
    #====Mirroring Off
    if [ "$2" == "off" ];
    then
        echo Disable All Mirror Ports
        let i=0
        #====Disable Port Mirroring
        while [ $i -lt $max_port ]
        do
            echo port: $i
            echo 0 > "sw"$i"/"$i"_mirror_rx"
            echo 0 > "sw"$i"/"$i"_mirror_tx"
            let i=i+1
        done
        exit 1
    fi
    #====Mirroring On
    if [ -z "$2" ];
    then
        echo " Error: Provide 2nd Argument, port number or 'off'"
        exit 1
    else
        #====Mirror Port
        echo "Mirror Port:" $2
        echo 1 > "sw"$2"/"$2"_mirror_rx"
        echo 1 > "sw"$2"/"$2"_mirror_tx"
        exit 1
    fi
fi

if [ "$1" == "sniffer" ];
then
    #====Sniffer Port Off
    if [ "$2" == "off" ];
    then
        echo Disable All Sniffer Port
        let i=0
        #====Disable Sniffer Port
        while [ $i -lt $max_port ]
        do
            echo 0 > "sw"$i"/"$i"_mirror_port"
            let i=i+1
        done
        exit 1
    fi
    #====Sniffer Port On
    if [ -z "$2" ];
    then
        echo " Error: Provide 2nd Argument, port number or 'off'"
        exit 1
    else
        #====Sniffer Port
        echo 1 > sw$2/$2_mirror_port
        echo port $2 set as sniffer port
        exit 1
    fi
fi