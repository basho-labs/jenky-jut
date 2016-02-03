#!/usr/bin/env sh
# we need the following environment variables:
#  DISTRIB_ID, ie Ubuntu, CentOS
#    we export DISTRIB_ID_L to be the all lowercase version of DISTRIB_ID
#  DISTRIB_RELEASE, ie 12.04, 14.04, 6.7

# sourcing /etc/*-release will error for centos, so parse first
if [ -s /etc/centos-release ]; then
    echo "parsing..."
    # parsing any of the /etc/*-release files works for CentOS 6, 7
    for r in /etc/*-release; do
        release=$(cat $r)
        export DISTRIB_ID=$(echo $release |awk -F' ' '{print $1}')
        # formats:
        #   CentOS release 6.7 (Core)
        #   CentOS Linux release 7.1.1503 (Core)
        export DISTRIB_RELEASE=$(echo $release \
            |awk -F' ' '{ if ($3 + 0.0 > 1.0) { print $3 } else if ($4 + 0.0 > 1.0) { print $4 * 1.0 }}')
        unset release
        if [ ! -z $DISTRIB_ID ] && [ ! -z $DISTRIB_RELEASE ]; then
            break
        fi
    done
elif ! . /etc/*-release >/dev/null 2>&1 ; then
    echo "not CentOS or Ubuntu?, extend set_os_vars.sh"
    exit 1
fi

export DISTRIB_ID_L=$(echo $DISTRIB_ID |tr '[:upper:]' '[:lower:]')
