#!/bin/bash
# Use ssh root@192.168.137.221 then select Yes.
DUT_IP=192.168.137.221

echo "Transferring files to $DUT_IP"
scp ./ksz8895_vlan_prio.py root@$DUT_IP:~/ 

echo "Open ssh $DUT_IP, make sure to select yes."
echo "Execute ./ksz8895_vlan_prio.py"
ssh root@$DUT_IP 'python ~/ksz8895_vlan_prio.py'