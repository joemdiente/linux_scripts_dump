# Vlan tag testing including single tag.
#

#Client Setup
CLIENT_MAC_VLAN10=00:80:0f:74:30:00
CLIENT_MAC_VLAN20=00:80:0f:74:30:02
CLIENT_IP_VLAN10=192.168.10.10
CLIENT_IP_VLAN20=192.168.20.20
CLIENT_NETIF_VLAN10=lan7430-1
CLIENT_NETIF_VLAN20=lan7430-2

#Host Setup
HOST_MAC_VLAN10=04:91:62:46:b4:58
HOST_MAC_VLAN20=04:91:62:46:b4:58
HOST_IP_VLAN10=192.168.10.1
HOST_IP_VLAN20=192.168.20.1

#Generic 
BC_MAC=ff:ff:ff:ff:ff:ff

#Send 10000 frames with C-TAG
REPEAT_COUNT=10

if [ "$1" = "vlan_10" ];
    then
        sudo ef tx $CLIENT_NETIF_VLAN10 \
        rep $REPEAT_COUNT eth \
        dmac $HOST_MAC_VLAN10 smac $CLIENT_MAC_VLAN10 \
        ctag pcp 1 dei 1 vid 10 et 0x0800 \
        ipv4 sip $CLIENT_IP_VLAN10 dip $HOST_IP_VLAN10 proto 6 \
        data ascii "aa55hello world"
fi

if [ "$1" = "vlan_20" ];
    then
        sudo ef tx $CLIENT_NETIF_VLAN20 \
        rep $REPEAT_COUNT eth \
        dmac $HOST_MAC_VLAN20 smac $CLIENT_MAC_VLAN20 \
        ctag pcp 7 dei 1 vid 20 et 0x0800 \
        ipv4 sip $CLIENT_IP_VLAN20 dip $HOST_IP_VLAN20 proto 6 help \
        data ascii "aa55hello world"
fi

#Test Only.
if [ "$1" = "test" ];
    then
        sudo ef tx lan7800-0 \
        rep 1 eth \
        dmac $HOST_MAC_VLAN10 smac $CLIENT_MAC_VLAN10 \
        ctag pcp 1 dei 1 vid 10 et 0x0800 \
        ipv4 proto 6 sip $CLIENT_IP_VLAN20 dip $HOST_IP_VLAN20 \
        data ascii "aa55hello world"
fi