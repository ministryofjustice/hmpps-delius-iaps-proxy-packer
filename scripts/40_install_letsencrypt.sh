#!/usr/bin/env bash

sudo -i

echo '========================================'
echo 'install letsencrypt certbot-nginx'
echo '========================================'
sudo yum install -y epel-release
sudo yum install -y certbot-nginx
sudo yum install -y tree

echo '========================================'
echo 'show certbot help to show its installed ok (we sometimes get python errors)'
echo '========================================'
certbot --help

echo '========================================'
echo 'install the certbot route53 plugin'
echo '========================================'
pip3 install certbot-dns-route53
certbot plugins
