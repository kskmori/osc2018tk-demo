#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "worker2上でPacemakerの状態表示を行う"
run_cmd ssh -t worker2 sudo crm_mon -Dr

