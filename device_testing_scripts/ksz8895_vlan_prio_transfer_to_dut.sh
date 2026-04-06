#!/bin/bash
# Use ssh root@192.168.137.221 then select Yes.

if [ "$1" = "clear_keys" ];
    then
        echo "Clearing known_hosts. Make sure to select \"Yes\"."
        ssh-keygen -f '/home/test/.ssh/known_hosts' -R '192.168.137.221'
        echo "Open ssh $DUT_IP, make sure to select yes."
fi

DUT_IP=192.168.137.221

echo "Transferring files to $DUT_IP"
scp ./*.py root@$DUT_IP:~/ 
scp ./ksz8895_vlan_prio_setup_host.sh root@$DUT_IP:~/ 

if [ "$1" = "read-clear-mib" ];
    then
        echo "Execute ./ksz8895_vlan_prio_read_mib.py"
        ssh root@$DUT_IP 'python ~/ksz8895_vlan_prio_read_mib.py'
fi

if [ "$1" = "exp" ];
    then
        echo "Execute ./ksz8895_vlan_prio_setup_switch.py"
        ssh root@$DUT_IP 'python ~/ksz8895_vlan_prio_setup_switch.py'
fi

if [ "$1" = "mirror" ];
    then
        if [ "$2" = "receive" ];
            then
            echo "Execute ./ksz8895_vlan_prio_setup_mirror_port2_4_to_port1.py"
            ssh root@$DUT_IP 'python ~/ksz8895_vlan_prio_setup_mirror_port2_4_to_port1.py'
        fi
        if [ "$2" = "transmit" ];
            then
            echo "Execute ./ksz8895_vlan_prio_setup_mirror_port5_to_port1.py"
            ssh root@$DUT_IP 'python ~/ksz8895_vlan_prio_setup_mirror_port5_to_port1.py'
        fi
fi  

if [ "$1" = "host_setup" ];
    then
        echo "Execute ./ksz8895_vlan_prio_setup_host.sh"
        ssh root@$DUT_IP 'chmod 775 ~/ksz8895_vlan_prio_setup_host.sh'
        ssh root@$DUT_IP '~/ksz8895_vlan_prio_setup_host.sh'
fi