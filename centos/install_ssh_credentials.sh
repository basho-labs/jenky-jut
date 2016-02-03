#!/usr/bin/env sh
mkdir -p ~/.ssh
cp /hostfiles/.ssh/* ~/.ssh/

eval $(ssh-agent -s)
for i in ls ~/.ssh/*; do
    case $i in
        *id_*.pub)
            sudo chown vagrant:vagrant $i
            ;;
        *id_*)
            sudo chown vagrant:vagrant $i
            sudo chmod 600 $i
            ssh-add $i </dev/null
            ;;
    esac
done
