#!/usr/bin/env sh
sudo yum install -y java-1.8.0-openjdk-devel maven
sudo bash -c "cat >> /etc/environment" << EOF
JAVA_HOME=$(dirname $(dirname $(dirname $(readlink -f `which java`))))
EOF
