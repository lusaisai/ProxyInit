mkdir /kcp

wget -O /kcp/kcptun.tar.gz https://github.com/xtaci/kcptun/releases/download/v20240107/kcptun-linux-amd64-20240107.tar.gz

tar -xzvf /kcp/kcptun.tar.gz -C /kcp/


cat << EOF > /kcp/config.json
{
        "smuxver": 2,
        "listen": ":6000-6600",
        "target": ":8388",
        "key": "lusaisai",
        "crypt": "twofish",
        "mode": "fast3",
        "mtu": 1400,
        "sndwnd": 2048,
        "rcvwnd": 2048,
        "datashard": 10,
        "parityshard": 0,
        "dscp": 0,
        "nocomp": true,
        "acknodelay": false,
        "nodelay": 1,
        "interval": 20,
        "resend": 2,
        "nc": 1,
        "sockbuf": 16777217,
        "smuxbuf": 16777217,
        "streambuf":4194304,
        "keepalive": 10,
        "pprof":false,
        "quiet":false,
        "tcp":false
}
EOF

# install supervisor
apt install supervisor

# add config
cat << EOF > /etc/supervisor/conf.d/kcptun.conf
[program:kcptun]
command=/kcp/server_linux_amd64 -c /kcp/config.json
EOF

# restart supervisor
service supervisor restart

# check
cat /kcp/config.json
