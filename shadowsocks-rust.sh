snap install shadowsocks-rust

# config
mkdir -p /var/snap/shadowsocks-rust/common/etc/shadowsocks-rust/
cat <<EOF > /var/snap/shadowsocks-rust/common/etc/shadowsocks-rust/config.json
{
    "server": "0.0.0.0",
    "server_port": 9000,
    "password": "$(uuidgen | head -c 32 | base64)",
    "fast_open": true,
    "method": "2022-blake3-aes-256-gcm"
}
EOF

# start
snap start --enable shadowsocks-rust.ssserver-daemon

#log
snap logs shadowsocks-rust.ssserver-daemon

# check
cat /var/snap/shadowsocks-rust/common/etc/shadowsocks-rust/config.json

