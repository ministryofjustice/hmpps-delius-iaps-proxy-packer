#!/usr/bin/env bash

sudo -i

sudo yum update -y
sudo yum install -y nginx tree

sudo systemctl enable nginx.service

# copy ca-bundle.crt which includes LetsEncrypt and other Root certs
if [ -d /etc/pki/tls/certs ]; then
    echo "/etc/pki/tls/certs already exists" ;
else
    mkdir -p /etc/pki/tls/certs
    echo "/etc/pki/tls/certs directory created"
fi

cp /tmp/assets/ssl/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt

mkdir -p /etc/nginx/conf.d

# ensure nginx user has permissions to nginx log directory
chown nginx:nginx /var/log/nginx
chmod 0700 /var/log/nginx

# nginx core configs
cp /tmp/assets/nginx_config_files/nginx.conf /etc/nginx/nginx.conf
cp /tmp/assets/nginx_config_files/proxy_params /etc/nginx/proxy_params
cp /tmp/assets/nginx_config_files/ssl_params /etc/nginx/ssl_params

# server-names
cp /tmp/assets/nginx_config_files/server-names.conf /etc/nginx/conf.d/server-names.conf

tree /etc/nginx
