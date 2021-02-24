#!/bin/bash
set -e

if [ $# != 1 ]; then
	echo "Usage: ./install.sh <file name>"
	exit
fi

bash $1
mv $1 installed/ -v
echo "bash $1" >> leaf_log

