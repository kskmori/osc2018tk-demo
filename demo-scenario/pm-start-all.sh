#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "Pacemaker を両ノードで起動"
run_cmd ansible-playbook ansible-pacemaker/20-pacemaker-start.yml

