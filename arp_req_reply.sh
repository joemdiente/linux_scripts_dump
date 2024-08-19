#
#   Fill up ARP table of switch by sending Request and Reply
#


# Filling up ARP Table by Pinging the Switch IP
for x in {6..200..1}
do
    #ARP Request with Switch VLAN 1
    sudo ef tx enxf8e43bedf19d \
    eth dmac ff:ff:ff:ff:ff:ff smac 00:00:c0:a8:0a:$(printf "%x\n" $x) \
    arp oper 1 ptype 0x0800 \
    sha 00:00:c0:a8:0a:$(printf "%x\n" $x) spa 192.168.137.$x \
    tha 00:00:00:00:00:00 tpa 192.168.137.111
done

# for x in {6..200..1}
# do
#     #ARP Request with Switch VLAN 10
#     sudo ef tx enxf8e43bedf19d \
#     eth dmac ff:ff:ff:ff:ff:ff smac 00:01:C1:00:00:$(printf "%x\n" $x) ctag vid 10 \
#     arp oper 1 ptype 0x0800 \
#     sha 00:01:C1:00:00:$(printf "%x\n" $x) spa 192.168.155.$x \
#     tha 00:00:00:00:00:00 tpa 192.168.155.111
# done

# for x in {6..200..1}
# do
#     #ARP Request with Switch VLAN 20
#     sudo ef tx enxf8e43bedf19d \
#     eth dmac ff:ff:ff:ff:ff:ff smac 40:84:32:00:00:$(printf "%x\n" $x) ctag vid 20 \
#     arp oper 1 ptype 0x0800 \
#     sha 40:84:32:00:00:$(printf "%x\n" $x) spa 192.168.200.$x \
#     tha 00:00:00:00:00:00 tpa 192.168.200.111
# done

