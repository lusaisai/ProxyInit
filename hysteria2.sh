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


# cert for local
cat /certs/3.crt
