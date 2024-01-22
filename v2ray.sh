# install
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)


# change config
cat << EOF > /usr/local/etc/v2ray/config.json
{
  "inbounds": [{
    "port": 10086,
    "protocol": "vmess",
    "settings": {
      "clients": [{ "id": "$(uuidgen)" }]
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF

# service
systemctl enable v2ray.service
service v2ray restart
service v2ray status

# check config
ip addr
cat /usr/local/etc/v2ray/config.json
