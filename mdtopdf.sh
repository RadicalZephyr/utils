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

test_for() {
    if hash $1 2>/dev/null
    then
        :
    else
        echo $NAME": No $1 found"
        exit 1
    fi
}

test_for pandoc
test_for latexmk

FILE=$1

DIR=`dirname $FILE`

if [ -f $DIR/prefix.tex ]
then
    PREFIX=`cat $DIR/prefix.tex`
else
    read -r -d '' PREFIX <<'EOF'
\documentclass[paper=a4, fontsize=11pt]{scrartcl}
\begin{document}
EOF

fi

if [ -f $DIR/suffix.tex ]
then
    SUFFIX=`cat $DIR/suffix.tex`
else
    read -r -d '' SUFFIX <<'EOF'
\end{document}
EOF

fi

BASENAME=`basename $FILE`
TEMPTEX=${BASENAME%md}tex
TEMPDIR=`mktemp -d`

echo "Prepending prefix"
echo "$PREFIX" >> $TEMPDIR/$TEMPTEX

echo "Generating content with pandoc"
pandoc -t latex $FILE >> $TEMPDIR/$TEMPTEX

echo
echo "Appending suffix"
echo "$SUFFIX" >> $TEMPDIR/$TEMPTEX
