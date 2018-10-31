#!#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "disconnect worker1"
run_cmd sh -c "
 VBoxManage controlvm worker1 setlinkstate1 off ;
 VBoxManage controlvm worker1 setlinkstate2 off"
