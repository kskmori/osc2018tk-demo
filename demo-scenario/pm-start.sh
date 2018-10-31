#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "Pacemaker をworker1で起動"
run_cmd ansible-playbook ansible-pacemaker/20-pacemaker-start.yml --tags=start-wait,all -l worker1
msg "Pacemaker をworker2で起動"
run_cmd ansible-playbook ansible-pacemaker/20-pacemaker-start.yml -l worker2

