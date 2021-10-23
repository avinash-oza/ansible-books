#! /bin/bash

# taken from https://irulan.net/throttling-linux-network-bandwidth-by-ip-address-and-time-of-day/

# cleanup existing shaping rules
tc qdisc del dev {{ interface_name }} root

tc qdisc add dev {{ interface_name }} root handle 1: cbq avpkt 1000 bandwidth 1000mbit

# max at 300KB/s * 8 = 2400kbit
tc class add dev {{ interface_name }} parent 1: classid 1:1 cbq rate 2400kbit allot 1500 prio 5 bounded isolated

{% for cidr in s3_ranges %}
tc filter add dev {{ interface_name }} parent 1: protocol ip prio 16 u32 match ip dst {{ cidr }} flowid 1:1
{% endfor %}
