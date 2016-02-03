#!/usr/bin/env sh
sudo -i -u vagrant sh <<'EOP'
. ~/.set_aws_creds.sh
cat >> ~/.profile << EOF
. ~/.set_aws_creds.sh
EOF
sudo bash -c "cat >> /etc/profile" << EOF
export PATH=$PATH:/usr/local/bin
EOF
. /etc/profile
. ~/.profile

sudo yum check-update
for s in $(ls /hostfiles/centos/install_*.sh); do chmod +x $s; done
for s in         \
  git            \
  s3cmd          \
  jdk_1_8        \
  kerl           \
  protobuf_2_5_0 \
  jenkins
do
    echo "installing '$s'"
    . /hostfiles/centos/install_${s}.sh
    if [ $? -ne 0 ]; then exit $?; fi
done
EOP
