#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

run_cmd kubectl scale --replicas=0 statefulsets/postgres
run_cmd kubectl scale --replicas=1 deployments/httpd-deployment
run_cmd kubectl cordon worker2
run_cmd kubectl scale --replicas=1 statefulsets/postgres
run_cmd kubectl scale --replicas=2 deployments/httpd-deployment
run_cmd kubectl uncordon worker2


