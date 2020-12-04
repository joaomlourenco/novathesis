#!/bin/bash

ME=$(basename $0)

if [ -z "$1" ]; then
	echo
	echo "Usage: $ME <new-version-number>"
	echo
fi

LINE=$(fgrep "%% Version" template.tex)
V=$(echo $LINE | cut -d '[' -f 2 | cut -d ']' -f 1)
D=$(echo $LINE | cut -d ' ' -f 3)
T=$(date  +%Y-%m-%d)
FILES=$(fgrep -rl "%% Version" . | fgrep -v $ME)

echo $D [$V] $T [$FILES]

perl -pi -e "s,%% Version $D \[$V\],%% Version $T \[$1\]," $FILES
