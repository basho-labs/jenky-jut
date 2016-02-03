#!/usr/bin/env sh
export TARGET_VM='centos'
export TARGET_VM_VARIANT='7'

if [ -z $AWS_ACCESS_KEY ] || [ -z $AWS_SECRET_KEY ]; then
    cat << EOP
Configure AWS Access and Secret Key
Refer to the user manual for s3cmd for detailed description of all options.

Access key and Secret key are your identifiers for Amazon S3

Access Key:
EOP
    read AWS_ACCESS_KEY
    echo "Secret Key:"
    read AWS_SECRET_KEY
fi

./cp_ssh_key.sh
