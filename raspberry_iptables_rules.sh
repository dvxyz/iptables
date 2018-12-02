#!/bin/bash

# Flush.
iptables -t filter -F
iptables -t nat -F

if [ "$1" = "clear" ] ; then
 echo "Cleared all rules."
 exit;
fi

# default policies
iptables -t filter -P OUTPUT ACCEPT
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP

# input exceptions.
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -s 10.8.0.0/24 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -s ch.velezschrod.xyz -j ACCEPT
iptables -A INPUT -s es.velezschrod.xyz -j ACCEPT
# iptables -A INPUT -s uk.velezschrod.xyz -j ACCEPT
iptables -A INPUT -p udp --dport 1194 -j ACCEPT

# forward exceptions
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s 10.8.0.0/24 -j ACCEPT
iptables -A FORWARD -s 192.168.0.0/24 -j ACCEPT
iptables -A FORWARD -s ch.velezschrod.xyz -j ACCEPT
iptables -A FORWARD -s es.velezschrod.xyz -j ACCEPT
# iptables -A FORWARD -s uk.velezschrod.xyz -j ACCEPT

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE
