#!/usr/bin/env sh
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk maven
# maven seems to set the link to java 7
sudo sh -c 'rm /etc/alternatives/java && ln -s /usr/lib/jvm/java-8-openjdk-amd64/bin/java /etc/alternatives/java'
sudo bash -c "cat >> /etc/environment" << EOF
JAVA_HOME=$(dirname $(dirname $(dirname $(readlink -f `which java`))))
EOF
