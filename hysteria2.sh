# system update
apt update
apt upgrade

# install hysteria
bash <(curl -fsSL https://get.hy2.sh/)

# config
cat << EOF > /etc/hysteria/config.yaml
# listen: :443

tls:
  cert: /certs/3.crt
  key: /certs/3.key

auth:
  type: password
  password: $(uuidgen)

masquerade:
  type: proxy
  proxy:
    url: https://www.linux.com/
    rewriteHost: true
EOF

# certs
mkdir -p /certs
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 \
  -nodes -keyout /certs/3.key -out /certs/3.crt -subj "/CN=linux.com" \
  -addext "subjectAltName=DNS:linux.com,DNS:*.linux.com,IP:10.0.0.1"


# install supervisor
apt install supervisor

# add config
cat << EOF > /etc/supervisor/conf.d/hysteria.conf
[program:hysteria]
command=hysteria server
EOF

# restart supervisor
service supervisor restart

# check
cat /etc/hysteria/config.yaml


# fingerprint for local
openssl x509 -noout -fingerprint -sha256 -in /certs/3.crt

# or pem
cat /certs/3.key /certs/3.crt > /certs/3.pem
cat /certs/3.pem

# client for sing-box
{
  "inbounds": [
    {
      "type": "mixed",
      "tag": "mixed-in",
      "listen": "::",
      "listen_port": 1080
    }
  ],
  "outbounds": [
    {
      "type": "hysteria2",
      "server": "",
      "server_port": 443,
      "up_mbps": 50,
      "down_mbps": 500,
      "password": "",
      "tls": {
        "enabled": true,
        "server_name": "linux.com",
        "certificate_path": "/etc/3.pem"
      }
    }
  ]
}

# openwrt init.d
root@OW:/etc/init.d# cat sing-box
#!/bin/sh /etc/rc.common
# Example script
# Copyright (C) 2007 OpenWrt.org

START=99

USE_PROCD=1

start_service() {
        procd_open_instance
        procd_set_param command sing-box -c /etc/sing-box/config.json run
        procd_close_instance
}

# client config.yaml
server: :443

auth:

tls:
  insecure: true
  pinSHA256: 

bandwidth:
  up: 50 mbps
  down: 500 mbps

socks5:
  listen: :3080

http:
  listen: :3081
