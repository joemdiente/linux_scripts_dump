#!/bin/sh
#######TC Initial Setup##########
tc qdisc add dev eth0 clsact
#IS1 L0
tc filter add dev eth0 ingress protocol all prio 0xffff handle 0 matchall \
     action goto chain 1000000
#IS1 L1
tc filter add dev eth0 ingress protocol all prio 0xffff handle 0 chain 1000000 flower \
     action goto chain 1100000
#IS1 L2
tc filter add dev eth0 ingress protocol all prio 0xffff handle 0 chain 1100000 flower \
     action goto chain 1200000
#IS2 L0
tc filter add dev eth0 ingress protocol all prio 0xffff handle 0 chain 1200000 flower \
     action goto chain 8000000
#IS2 L1
tc filter add dev eth0 ingress protocol all prio 0xffff handle 0 chain 8000000 flower \
     action goto chain 8100000
#properly registering
tc filter add dev eth0 ingress chain 8000000 prio 10 handle 42 protocol ipv4 flower skip_sw \
  src_ip 192.168.137.1 \
  dst_ip 224.0.0.22/255.255.255.0 \
  ip_proto udp \
  action drop \
  action goto chain 8100000