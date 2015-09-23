#!/usr/bin/env sh

set -e

LIB_TARGET="/usr/local/lib/urm15/"
BIN_TARGET="/usr/local/bin/"

rm $LIB_TARGET/converturm.py
rm $LIB_TARGET/urm15template.c
rm $LIB_TARGET/urmcompile.sh

rm $BIN_TARGET/urm15c
