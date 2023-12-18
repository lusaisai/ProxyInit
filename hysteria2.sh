# install hysteria
bash <(curl -fsSL https://get.hy2.sh/)

# config
cat << EOF > /etc/hysteria/config.yaml
# listen: :443

tls:
  cert: /certs/2.crt
  key: /certs/2.key

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
  -nodes -keyout /certs/2.key -out /certs/2.crt -subj "/CN=linux.com" \
  -addext "subjectAltName=DNS:linux.com,DNS:*.linux.com,IP:10.0.0.1"


# system update
apt update
apt upgrade

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

