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
iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT
iptables -A INPUT -s ch.velezschrod.xyz -j ACCEPT
iptables -A INPUT -s es.velezschrod.xyz -j ACCEPT
# iptables -A INPUT -s uk.velezschrod.xyz -j ACCEPT
iptables -A INPUT -p udp --dport 1194 -j ACCEPT
iptables -A INPUT -p tcp --dport 32400 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# smtp services
iptables -A INPUT -p tcp --match multiport --dports 25,110,143,587,993,995,2525 -j ACCEPT

# forward exceptions
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s 10.8.0.0/24 -j ACCEPT
iptables -A FORWARD -s 192.168.0.0/24 -j ACCEPT
iptables -A FORWARD -s ch.velezschrod.xyz -j ACCEPT
iptables -A FORWARD -s es.velezschrod.xyz -j ACCEPT
# iptables -A FORWARD -s uk.velezschrod.xyz -j ACCEPT

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE

iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 8001 -j DNAT --to 192.168.0.10:8001
iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 8002 -j DNAT --to 192.168.0.10:8002

iptables -t nat -A POSTROUTING -p tcp --dport 8001 -j MASQUERADE
iptables -t nat -A POSTROUTING -p tcp --dport 8002 -j MASQUERADE

iptables -A INPUT -p tcp --match multiport --dports 22,25,80,110,143,443,993,995,2525 -j LOG --log-prefix='[netfilter] '  --log-level 1
iptables -A INPUT -p udp --dport 1194 -j LOG --log-prefix='[netfilter] '
