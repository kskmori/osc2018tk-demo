#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "Pacemaker を両ノードで停止"
run_cmd ansible-playbook ansible-pacemaker/30-pacemaker-stop.yml

