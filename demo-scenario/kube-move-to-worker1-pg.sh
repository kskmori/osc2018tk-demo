#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "postgresを一旦停止"
run_cmd kubectl scale --replicas=0 statefulsets/postgres
#run_cmd kubectl scale --replicas=1 deployments/httpd-deployment
echo "#"
msg "worker2での起動を抑止"
run_cmd kubectl cordon worker2
echo "#"
msg "postgresを再起動"
run_cmd kubectl scale --replicas=1 statefulsets/postgres
#run_cmd kubectl scale --replicas=2 deployments/httpd-deployment
echo "#"
msg "worker2での起動抑止を解除"
run_cmd kubectl uncordon worker2


