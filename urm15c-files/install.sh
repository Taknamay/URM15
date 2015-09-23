#!/usr/bin/env sh

set -e

LIB_TARGET="/usr/local/lib/urm15/"
BIN_TARGET="/usr/local/bin/"

if [ ! -d "$LIB_TARGET" ]; then
  mkdir $LIB_TARGET
fi

cp converturm.py urm15template.c urmcompile.sh $LIB_TARGET
cp urm15c $BIN_TARGET
