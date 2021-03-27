#!/bin/bash

ME=$(basename $0)
VF="NOVAthesisFiles/nt-version.sty"

V=$(cat $VF | fgrep novathesisversion | sed -e 's/.*{\(.*\)}$/\1/')
D=$(cat $VF | fgrep novathesisdate | sed -e 's/.*{\(.*\)}$/\1/')
echo Current DATE=$D VERSION=$V

if [ -z "$1" ]; then
	echo
	echo "Usage: $ME <new-version-number>"
	echo
	exit 1
fi

T=$(date  +%Y-%m-%d)
FILES="template.tex novathesis.cls"
echo New DATE=$T VERSION=$1

perl -pi  -e "s,$D,$T," $FILES
perl -pi  -e "s,\[$V\],\[$1\]," $FILES
perl -pi -e "s,$D,$T," $VF
perl -pi -e "s,$V,$1," $VF

exit 0

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
