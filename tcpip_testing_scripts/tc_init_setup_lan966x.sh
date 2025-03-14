#!/bin/sh
#######TC Initial Setup##########
tc qdisc del dev eth0 clsact
tc qdisc add dev eth0 clsact

#IS1 L0
tc filter add dev eth0 ingress protocol all prio 0xffff handle 0 matchall skip_sw \
action goto chain 1000000
#IS1 L1
tc filter add dev eth0 ingress protocol all prio 0xffff handle 0 chain 1000000 flower skip_sw \
action goto chain 1100000
#IS1 L2
tc filter add dev eth0 ingress protocol all prio 0xffff handle 0 chain 1100000 flower skip_sw \
action goto chain 1200000
#IS2 L0
tc filter add dev eth0 ingress protocol all prio 0xffff handle 0 chain 1200000 flower skip_sw \
action goto chain 8000000
#IS2 L1
tc filter add dev eth0 ingress protocol all prio 0xffff handle 0 chain 8000000 flower skip_sw \
action goto chain 8100000

#  Working match in dst_ip 224.0.0.0/255.255.255.0 (Filtering multicast to 224.0.0.0/24)
tc qdisc del dev eth0 clsact
tc qdisc add dev eth0 clsact
tc filter add dev eth0 ingress chain 0 prio 10000 handle 10000 matchall skip_sw action goto chain 8000000
tc filter add dev eth0 ingress protocol ip prio 0x0 handle 0 chain 8000000 flower skip_sw dst_ip 224.0.0.22/255.255.255.0 action drop action goto chain 8100000


### Test ###
# Match in dst_mac but drop other
tc qdisc del dev eth0 clsact
tc qdisc add dev eth0 clsact
tc filter add dev eth0 ingress chain 0 prio 10000 handle 10000 matchall skip_sw action goto chain 1000000
tc filter add dev eth0 ingress protocol ip prio 0 handle 0 chain 1000000 flower skip_sw dst_mac 01:00:5e:00:00:16/FF:00:00:00:00:00 action pass goto chain 8000000 # Allow to pass
# tc filter add dev eth0 ingress protocol ip prio 0x0 handle 0 chain 8000000 flower skip_sw dst_ip 224.0.0.22/0.0.0.0 action drop action goto chain 8100000 
cat /sys/kernel/debug/lan966x/vcaps/is1_0
cat /sys/kernel/debug/lan966x/vcaps/is2_0
### Help ###
#-s show DETAILED Statistics
#ingress is a special qdisc under clsact(?)
#check output
while :; do clear && tc -s qdisc show dev eth0 ingress && tc -s filter show dev eth0 ingress && tc -s chain show dev eth0 ingress; sleep 1; done


################################Test Packet#####################################
sudo ef tx enxf8e43bedf19d \
eth smac 00:01:C1:00:00:02 dmac 01:00:5e:00:00:16 \
ipv4 sip 192.168.137.1 dip 224.0.0.22 ttl 1
