#!/bin/sh
#Disabling/Enabling HSR Script
#Written By: Joemel John A. Diente <joemdiente@gmail.com>

#Variables
ksz_phy_ports=5

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
    echo "          danh = set port x and port x + 1 as HSR ports in DANH"
    echo "          redbox = set port x and port x + 1 as HSR ports; other ports are redbox ports"
    echo "          off = reset to default mode"
    echo "  Example:"
    echo "          ./ksz9477_hsr.sh [danh/redbox] [port number]"
    echo "  Note:"
    echo "          Only consecutive ports can be HSR port. (Limitation)"
    exit 1
fi

#====Main
if [ "$1" == "danh" ];
then
    if [ -z "$2" ];
    then
        echo " Error: Provide 2nd Argument, port number "
        exit 1
    else
        if [ "$(($2+1))" -gt "$ksz_phy_ports" ]
        then 
            echo " Error: Port number is greater than number of PHY ports"
            exit 1
        else
            #====DANH Mode
            current_config="DANH Mode"
            fw_setenv multi_dev 0
            fw_setenv eth1_ports $((2**($2)+2**($2+1)))
            fw_setenv eth1_proto hsr
            fw_setenv eth1_vlan 0x7e
            fw_setenv eth2_proto    #Not Really Needed;Cleaning up "RedBox" Config
            fw_setenv eth2_vlan     #Not Really Needed;Cleaning up "RedBox" Config
            fw_setenv stp 0

            #====HSR ports
            echo "HSR Ports:" $2 "and" $(($2+1))
        fi
    fi
fi

if [ "$1" == "redbox" ];
then
    if [ -z "$2" ];
    then
        echo " Error: Provide 2nd Argument, port number"
        exit 1
    else
        if [ "$(($2+1))" -gt "$ksz_phy_ports" ]
        then 
            echo " Error: Port number is greater than number of PHY ports"
            exit 1
        else
            #====RedBox Mode
            current_config="RedBox Mode"
            fw_setenv multi_dev 1
            fw_setenv eth1_ports $((2**($2)+2**($2+1)))
            fw_setenv eth1_proto hsr
            fw_setenv eth1_vlan 0x7e
            fw_setenv eth2_proto redbox
            fw_setenv eth2_vlan 0x7f
            fw_setenv stp 0

            #====HSR ports
            echo "HSR Ports:" $2 "and" $(($2+1))
        fi
    fi
fi

if [ "$1" == "off" ];
then
    #===Remove Variables
    current_config="None"
    fw_setenv multi_dev
    fw_setenv eth1_ports
    fw_setenv eth1_proto
    fw_setenv eth1_vlan
    fw_setenv eth2_proto
    fw_setenv eth2_vlan
    fw_setenv stp
fi
echo "Configuration: $current_config"
echo "Restart to Apply Changes!"
echo "Exiting...."
exit 1