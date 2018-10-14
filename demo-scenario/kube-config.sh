#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "node構成を表示"
run_cmd kubectl get node
msg "pods一覧を表示"
run_cmd kubectl get pods -o wide

msg "deployments一覧を表示"
run_cmd kubectl get deployments
msg "statefulsets一覧を表示"
run_cmd kubectl get statefulsets


