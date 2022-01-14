#!/usr/bin/env bash

sudo -i

#sudo yum install -y amazon-cloudwatch-agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/centos/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
rm -rf amazon-cloudwatch-agent.rpm
