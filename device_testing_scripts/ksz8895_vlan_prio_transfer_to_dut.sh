#!/bin/bash
# Use ssh root@192.168.137.221 then select Yes.
DUT_IP=192.168.137.221

echo "Transferring files to $DUT_IP"
scp ./ksz8895_vlan_prio_setup_switch.py root@$DUT_IP:~/ 
scp ./ksz8895_vlan_prio_setup_host.sh root@$DUT_IP:~/ 
scp ./ksz8895_vlan_prio_setup_mirror_port5_to_port1.py root@$DUT_IP:~/ 
echo "Open ssh $DUT_IP, make sure to select yes."

if [ "$1" = "exp" ];
    then
        echo "Execute ./ksz8895_vlan_prio_setup_switch.py"
        ssh root@$DUT_IP 'python ~/ksz8895_vlan_prio_setup_switch.py'
fi

if [ "$1" = "mirror" ];
    then
        echo "Execute ./ksz8895_vlan_prio_setup_mirror_port5_to_port1.py"
        ssh root@$DUT_IP 'python ~/ksz8895_vlan_prio_setup_mirror_port5_to_port1.py'
fi

if [ "$1" = "host_setup" ];
    then
        echo "Execute ./ksz8895_vlan_prio_setup_host.sh"
        ssh root@$DUT_IP 'chmod 775 ~/ksz8895_vlan_prio_setup_host.sh'
        ssh root@$DUT_IP 'python ~/ksz8895_vlan_prio_setup_host.sh'
fi