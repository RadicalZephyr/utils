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

SUBDIR=$1
HOST=$2
REMOTE_DIR=$3

if [ -d "$0" ]
then

    git archive --format tar.gz master $SUBDIR | ssh $HOST "tar -C $REMOTE_DIR -xzf - "
    pushd $SUBDIR
    ant release && scp bin/Main-release.apk $HOST:"~"/$REMOTE_DIR

fi
