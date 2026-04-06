# Vlan tag testing including double tag.
#
SELF_NET1=enxf8e43bedf19d
SELF_MAC1=f8:e4:3b:ed:f1:01
LP_MAC1=D8:3A:DD:68:6D:BF

#Test MACs 
TEST_MAC1=FC:0F:E7:00:00:02  #Microchip
TEST_MAC2=00:01:C1:00:00:02  #Vitesse
TEST_MAC3=E0:BF:B2:00:00:02

#Test IPs
TEST_IP1=192.168.137.150
TEST_IP2=192.168.137.25
TEST_IP3=30.30.30.30
TEST_IP4=1.1.1.1

#Generic 
BC_MAC=ff:ff:ff:ff:ff:ff

#Send a frame with S-TAG and C-TAG
for x in {1..7}
do
    sudo ef tx $SELF_NET1 eth dmac $TEST_MAC2 smac $TEST_MAC1 \
    et 0x88A8 stag pcp 0 dei 0 vid 7 \
    et 0x8100 ctag pcp $x dei 0 vid 6 \
    ipv4 sip $TEST_IP1 dip $TEST_IP2 proto 6 \
    data ascii "aa55hello world"
    # sleep 1
done

for x in {1..7}
do
    sudo ef tx $SELF_NET1 eth dmac ff:ff:ff:ff:ff:ff smac $TEST_MAC1 \
    et 0x8100 ctag pcp $x dei 0 vid 9 \
    ipv4 sip $TEST_IP1 dip $TEST_IP2 proto 6 \
    data ascii "aa55hello world"
    # sleep 1
done

