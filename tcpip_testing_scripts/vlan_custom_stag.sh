# Force Arp Announcement
#
SELF_NET1=enxf8e43bedf19d
SELF_MAC1=f8:e4:3b:ed:f1:01

TEST_MAC1=00:01:C1:00:00:02

sudo ef tx $SELF_NET1 eth dmac ff:ff:ff:ff:ff:ff smac $TEST_MAC1 \
stag et 0x0800 pcp 5 dei 0 vid 15 \
ipv4 ver 4 dscp 1 sip 10.10.10.1 dip 10.10.10.2

