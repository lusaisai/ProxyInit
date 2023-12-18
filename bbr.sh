sysctl net.ipv4.tcp_congestion_control

# run below if not bbr
echo "net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr" >>  /etc/sysctl.conf

sysctl -p

# check again
sysctl net.ipv4.tcp_congestion_control
