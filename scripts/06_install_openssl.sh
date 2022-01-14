#!/usr/bin/env bash

sudo -i
CURRENT_DIR=$(pwd)

sudo yum update -y
sudo yum group install 'Development Tools' -y
sudo yum install perl-core zlib-devel -y

cd /usr/local/src/
sudo wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz
sudo tar -xf openssl-1.1.1c.tar.gz
cd openssl-1.1.1c
sudo ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
sudo make
sudo make test
sudo make install

cd /etc/ld.so.conf.d/
cp /tmp/assets/openssl/openssl-1.1.1c.conf /etc/ld.so.conf.d/openssl-1.1.1c.conf
sudo ldconfig -v
sudo mv /bin/openssl /bin/openssl.backup

cp /tmp/assets/openssl/openssl.sh /etc/profile.d/openssl.sh
source /etc/profile.d/openssl.sh
openssl version -a

cd $CURRENT_DIR
