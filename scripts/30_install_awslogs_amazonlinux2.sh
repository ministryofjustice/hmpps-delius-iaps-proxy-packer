#!/usr/bin/env bash

sudo -i

sudo yum update -y
sudo yum install -y awslogs

#download installer
#curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O

#create aws logs directories as installer does not
mkdir -p /etc/awslogs
mkdir -p /var/awslogs/state/

#create dummy config
cat > /tmp/awslogs.conf <<- EOF
[general]
state_file = /var/awslogs/state/agent-state
EOF

#run installer with dummy config, to be replaced on ec2 autostart up bootstrap
#python ./awslogs-agent-setup.py --region eu-west-2 -n -c /tmp/awslogs.conf

sudo systemctl enable awslogsd.service