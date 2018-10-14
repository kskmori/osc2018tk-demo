#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "worker2 の Pacemaker を一旦停止"
run_cmd ansible-playbook ansible-pacemaker/30-pacemaker-stop.yml -l worker2
msg "worker2 の Pacemaker を再起動"
run_cmd ansible-playbook ansible-pacemaker/20-pacemaker-start.yml -l worker2

