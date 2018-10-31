#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

#run_cmd kubectl scale --replicas=0 statefulsets/postgres
msg "httpdの一つを一旦停止"
run_cmd kubectl scale --replicas=1 deployments/httpd
echo "#"
msg "worker2での起動を抑止"
run_cmd kubectl cordon worker2
#run_cmd kubectl scale --replicas=1 statefulsets/postgres
echo "#"
msg "httpdの起動数を2に戻す"
run_cmd kubectl scale --replicas=2 deployments/httpd
echo "#"
msg "worker2での起動抑止を解除"
run_cmd kubectl uncordon worker2


