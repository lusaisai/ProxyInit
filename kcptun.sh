mkdir /kcp

wget -O /kcp/kcptun.tar.gz https://github.com/xtaci/kcptun/releases/download/v20240107/kcptun-linux-amd64-20240107.tar.gz

tar -xzvf /kcp/kcptun.tar.gz -C /kcp/


# install supervisor
apt install supervisor

# add config
cat << EOF > /etc/supervisor/conf.d/kcptun.conf
[program:kcptun]
command=/kcp/server_linux_amd64 -l :6000 -t 127.0.0.1:18000 --mode fast3 --sndwnd 4096 --key `uuidgen`
EOF

# restart supervisor
service supervisor restart

# check
cat /etc/supervisor/conf.d/kcptun.conf
