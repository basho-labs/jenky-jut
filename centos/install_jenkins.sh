#!/usr/bin/env sh
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo mkdir /var/lib/jenkins/.ssh
sudo cp /home/vagrant/.ssh/* /var/lib/jenkins/.ssh/
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 0600 /var/lib/jenkins/.ssh/*
sudo cp /home/vagrant/.gitconfig /var/lib/jenkins/.gitconfig
sudo chown jenkins:jenkins /var/lib/jenkins/.gitconfig
sudo service jenkins start
