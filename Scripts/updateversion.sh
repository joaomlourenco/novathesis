#!/bin/bash

ME=$(basename $0)

LINE=$(grep "^%% Version" template.tex)
V=$(echo $LINE | cut -d '[' -f 2 | cut -d ']' -f 1)
D=$(echo $LINE | cut -d ' ' -f 3)
FILES=$(grep -rl "^%% Version" . | fgrep -v $ME)
echo Current DATE=$D VERSION=$V FILES=[$FILES]


if [ -z "$1" ]; then
	echo
	echo "Usage: $ME <new-version-number>"
	echo
	exit 1
fi

T=$(date  +%Y-%m-%d)

echo New DATE=$T VERSION=$1

perl -pi -e "s,%% Version $D \[$V\],%% Version $T \[$1\]," $FILES
