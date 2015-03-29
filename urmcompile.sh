#!/usr/bin/env sh

######################################################################
#
# Copyright 2015 Jason K. MacDuffie
#
# This file is part of URM15c.
#
# URM15c is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# URM15c is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with URM15c.  If not, see <http://www.gnu.org/licenses/>.
#
#######################################################################
#
# This is a front-end for URM15c.

printhelp() {
	echo "Usage: urm15c <filename> [options]"
}

set -e

BASEDIR=$(dirname $0)

if [ "$1" = "" ]
then
  printhelp
  exit 1
fi

if [ "$1" = "--help" ]
then
  printhelp
  exit 0
fi

echo "Converting from URM15 to C..."
python $BASEDIR/converturm.py $1 > /tmp/tmp.c
echo "Compiling the C program..."
cc /tmp/tmp.c $2 $3
echo "Cleaning up..."
rm /tmp/tmp.c
