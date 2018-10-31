#!/bin/bash

which pv >/dev/null 2> /dev/null
if [ $? -eq 0 ]; then
 USE_PV=1
else
 USE_PV=0
fi

msg() {
  echo -n "## $@"
  read line
}

run_cmd() {
  if [ $USE_PV -eq 1 ]; then
    echo -n "# $@" | pv -qL $[20+$RANDOM%5]
  else
    echo -n "# $@"
  fi
  read line
  "$@"
}


