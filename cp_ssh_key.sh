#!/usr/bin/env sh
case SSH_KEY in
    ~/.ssh/id_*)
        ssh_key=$SSH_KEY
        ;;
    id_*)
        ssh_key=~/.ssh/$SSH_KEY
        ;;
    *)
        ssh_key=~/.ssh/id_rsa
        ;;
esac

if [ ! -e $ssh_key ]; then
    echo "usage: SSH_KEY=<ssh_key_path> ./cp_ssh_key.sh"
    exit 1
fi

mkdir -p .ssh
cp $ssh_key .ssh/id_rsa
if [ -e $ssh_key.pub ]; then
    cp $ssh_key.pub .ssh/id_rsa.pub
fi

openssl rsa -in .ssh/id_rsa -out .ssh/id_rsa.stripped
mv .ssh/id_rsa.stripped .ssh/id_rsa
