#!/usr/bin/env bash

sudo -i

yum install -y deltarpm
yum install -y vim
yum install -y unzip
yum install -y tree
yum install -y jq
#yum remove -y *-devel
yum remove -y *-header

yum groups mark convert

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum update  -y
yum install -y yum-utils
yum install -y device-mapper-persistent-data
yum install -y lvm2
yum install -y bind-utils
