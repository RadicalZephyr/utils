#!/bin/bash

NAME=$(basename $0)
TEMP=$(getopt -o '' -n $NAME -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true; do
  case "$1" in
    -- ) shift; break ;;
  esac
done

if hash pandoc 2>/dev/null
then
    :
else
    echo $NAME": No pandoc found"
fi
