#!/bin/bash

BASEDIR=$(dirname "$0")
. $BASEDIR/common.sh

run_cmd watch -n 1 'kubectl get node; echo ; kubectl get pods -o wide'

