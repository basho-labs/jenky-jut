#!/usr/bin/env sh
sudo -i -u vagrant sh <<'EOP'
. ~/.set_aws_creds.sh
cat >> ~/.profile << EOF
. ~/.set_aws_creds.sh
EOF
. /etc/profile
. ~/.profile

sudo apt-get update
for s in $(ls /hostfiles/ubuntu/install_*.sh); do chmod +x $s; done
for s in         \
  git            \
  s3cmd          \
  jdk_1_8        \
  kerl           \
  protobuf_2_5_0 \
  jenkins
do
    echo "installing '$s'"
    . /hostfiles/ubuntu/install_${s}.sh
    if [ $? -ne 0 ]; then exit $?; fi
done
EOP
