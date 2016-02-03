#!/usr/bin/env sh
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins
sudo mkdir /var/lib/jenkins/.ssh
sudo cp /home/vagrant/.ssh/* /var/lib/jenkins/.ssh/
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 0600 /var/lib/jenkins/.ssh/*
sudo cp /home/vagrant/.gitconfig /var/lib/jenkins/.gitconfig
sudo chown jenkins:jenkins /var/lib/jenkins/.gitconfig
