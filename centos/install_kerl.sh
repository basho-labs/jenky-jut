#!/usr/bin/env sh
ERL_VERSION="R16B02-basho8"
ERL_VERSION_U=$(echo $ERL_VERSION |tr '-' '_')

. /hostfiles/set_os_vars.sh

. /hostfiles/centos/install_ssh_credentials.sh

sudo yum install -y curl gcc gcc-c++ glibc-devel make autoconf ncurses-devel openssl-devel pam-devel

if [ -s /opt/erlang/kerl ]; then
    echo "kerl already installed"
else
    sudo mkdir -p /opt/erlang/
    curl -O https://raw.githubusercontent.com/spawngrid/kerl/master/kerl
    chmod a+x kerl
    sudo mv kerl /opt/erlang/
    sudo ln -s /opt/erlang/kerl /usr/local/bin/kerl
fi

# if present, use pre-built kerl build
ERL_TARBALL_BASENAME="erlang-${ERL_VERSION}-${DISTRIB_ID_L}-${DISTRIB_RELEASE}.tar.gz"
S3_URL="s3://builds.basho.com/erlangs/kerl-builds/${DISTRIB_ID_L}/$DISTRIB_RELEASE/${ERL_VERSION}/${ERL_TARBALL_BASENAME}"

if [ -d /opt/erlang/${ERL_VERSION} ]; then
    echo "${ERL_VERSION} already installed"
else
    s3cmd get $S3_URL
    if [ -s $ERL_TARBALL_BASENAME ]; then
        echo "untarring $ERL_TARBALL_BASENAME"
        sudo tar xzf $ERL_TARBALL_BASENAME --directory=/opt/erlang/
    else
        echo "building and installing $ERL_VERSION"
        sudo -i sh -c "CFLAGS=\"-DOPENSSL_NO_EC=1\" \
            kerl build git git://github.com/basho/otp.git OTP_${ERL_VERSION_U} ${ERL_VERSION}"
        sudo -i kerl install ${ERL_VERSION} /opt/erlang/${ERL_VERSION}

        tar -czvf $ERL_TARBALL_BASENAME --directory=/opt/erlang/ ${ERL_VERSION}
        s3cmd put $ERL_TARBALL_BASENAME $S3_URL
    fi
fi

if [ ! -e /opt/erlang/current ]; then
    sudo ln -s /opt/erlang/${ERL_VERSION} /opt/erlang/current
fi

cd /usr/local/bin
sudo find /opt/erlang/current/bin -exec ln -s '{}' \;
cd ~

. /opt/erlang/current/activate

# ensure crypto
erl -eval "crypto:start(), halt()." -noshell
if [ $? != 0 ]; then exit $?; fi

sudo bash -c "cat > /etc/profile.d/kerl_activate.sh" <<EOF
. /opt/erlang/current/activate
EOF
