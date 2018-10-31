#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "worker1上でPacemakerの状態表示を行う"
run_cmd ssh -t worker1 sudo crm_mon -Dr

