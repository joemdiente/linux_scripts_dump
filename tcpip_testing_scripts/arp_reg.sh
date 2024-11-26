# Force Arp Announcement
#

for x in {3..250..1}
do
    sudo ef tx enxf8e43bedf19d \
    eth dmac ff:ff:ff:ff:ff:ff smac f8:e4:3b:ed:f1:$(printf "%x\n" $x) \
    arp oper 1 ptype 0x0800 \
    sha f8:e4:3b:ed:f1:$(printf "%x\n" $x) spa 192.168.137.$x \
    tha 00:00:00:00:00:00 tpa 192.168.137.99
done