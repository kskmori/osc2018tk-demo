#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

msg "node情報とpods情報を1秒ごとに表示し続ける"
run_cmd watch -n 1 'kubectl get node; echo ; kubectl get pods -o wide'
