#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "reconnect worker1"
run_cmd sh -c "
 VBoxManage controlvm worker1 setlinkstate1 on ;
 VBoxManage controlvm worker1 setlinkstate2 on"


