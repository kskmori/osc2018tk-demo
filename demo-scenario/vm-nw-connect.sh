#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

if ! which VBoxManage >/dev/null; then
    echo "This script must be run on the host node."
    exit 1
fi

if VBoxManage list runningvms | grep "worker1" >/dev/null; then
    # VM is running state
    msg "reconnect worker1"
    run_cmd sh -c "
     VBoxManage controlvm worker1 setlinkstate1 on ;
     VBoxManage controlvm worker1 setlinkstate2 on"

else
    # VM is not running state
    msg "reconnect worker1"
    run_cmd sh -c "
     VBoxManage modifyvm worker1 --cableconnected1 on ;
     VBoxManage modifyvm worker1 --cableconnected2 on"

fi
