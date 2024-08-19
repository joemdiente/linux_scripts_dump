vson -d 192.168.137.111 -u admin -p "" -c call --dump-req ptp.config.clocks.defaultDs.add "0" '{
    "deviceType": "ordBound",
    "twoStepFlag": false,
    "priority1": 128,
    "priority2": 128,
    "oneWay": false,
    "domainNumber": 0,
    "protocol": "ethernet",
    "vid": 1,
    "pcp": 0,
    "mep": 1,
    "clkDom": 0,
    "dscp": 0,
    "profile": "ieee1588",
    "localPriority": 128,
    "filterType": "basicPhaseLow",
    "pathTraceEnable":false
}'

# "key": 2,
# vson -d 192.168.137.111 -u admin -p "" -c grep ptp.config.clocks.defaultDs
# vson -d 192.168.137.111 -u admin -p "" -c call --dump-req ptp.capabilities.get
# vson -d 192.168.137.111 -u admin -p "" -c call --dump-res ptp.config.clocks.defaultDs.get