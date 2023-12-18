# system update
apt update
apt upgrade

# install shadowsocks
apt install shadowsocks-libev

# config
cat <<EOF > /etc/shadowsocks-libev/config.json
{
    "server": "0.0.0.0",
    "mode":"tcp_and_udp",
    "server_port":8388,
    "local_port":1080,
    "password":"`uuidgen`",
    "timeout":86400,
    "method":"chacha20-ietf-poly1305"
}
EOF

# check
cat /etc/shadowsocks-libev/config.json

# start/restart
service shadowsocks-libev restart

