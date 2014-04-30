#!/bin/bash

NAME=$(basename $0)
TEMP=$(getopt -o 'd:' --long 'destination-name:' -n $NAME -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true; do
    case "$1" in
        -d | --destination-name ) DNAME="$2"; shift 2;;
        -- ) shift; break ;;
  esac
done

HOST=$1
REMOTE_DIR=$2
SUBDIR=$3

if [ -n "$DNAME" ]
then
    DNAME="--transform s/$SUBDIR/$DNAME/"
fi

if [ -d "$SUBDIR" ]
then

    git archive --format tar.gz master $SUBDIR | ssh $HOST "tar -xzf - -C $REMOTE_DIR $DNAME"
    pushd $SUBDIR
    android update project -p ./
    ant release && scp bin/Main-release.apk $HOST:"~"/$REMOTE_DIR
    popd
fi
