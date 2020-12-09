#!/bin/bash

#===================================================================
# Main configuration variables
#===================================================================
NTURL="https://github.com/joaomlourenco/novathesis.git"


#===================================================================
# Process command line arguments
#===================================================================
function usage() {
	echo 'Usage: clone-in-overleaf [-k] [-g github_url] [-s school] <overleaf_url>'
	echo "-k            keep Overleaf repository"
	echo "-g <URL>      alternative URL for the base NOVAthesis repository"
	echo "-s <school>   remove definitions for all schools except '<school>'"
	exit 1
}


while getopts ":g:s:" opt; do
  case ${opt} in
	k ) # process option h
		KEEP="true"
		;;
	s ) # process option h
		SCHOOL="$OPTARG"
		;;
    g ) # process option h
		NTURL="$OPTARG"
		;;
  esac
done
shift $((OPTIND -1))

[[ -z "$1" || -n "$2" ]] && usage

OLURL=$1

TMPDIR="$(mktemp -d ./temp.XXXXXX)"

# echo Cloning NOVAthesis from
# echo "	G=$NTURL"
# echo "to Overleaf project"
# echo "	OLURL=$OLURL"

# Clone repositories in parallel
cd "$TMPDIR"
NTNAME="$(echo $NTURL | sed -e 's,.*/,,' -e 's/\.git$//')"
OLNAME="$(echo $OLURL | sed -e 's,.*/,,')"
[ -d "$NTNAME" ] || git clone "$NTURL"&
[ -d "$OLNAME" ] || git clone "$OLURL"&
wait

# Clean novathesis if -s is given
if [ -n "$SCHOOL" ]; then
	cd $NTNAME
	SD=$(dirname $SCHOOL)
	SF=$(basename $SCHOOL)
	mv NOVAthesisFiles/Schools/$SCHOOL .
	rm -rf NOVAthesisFiles/Schools
	mkdir -p NOVAthesisFiles/Schools/$SD
	mv ./$SF NOVAthesisFiles/Schools/$SD
	cd ..
fi

# Clean onverleaf directory
cd $OLNAME
find . -type d | grep -v -e '^.$' -e '/.git' | while read i; do git rm -rf "$i"; done
mv ../$NTNAME/* .		# get files from NOVAthesis folder
mv template.tex main.tex	# Overleaf prefers "main.tex" as main file
rm f _config.yml template.pdf
rm -rf Scripts Examples
git add .					# Add all files to git
git commit -m 'Initial version'
git push
cd ..

# Clean temp directory
if [ -n "$KEEP" ]; then
	mv $TMPDIR/$OLNAME .
fi
rm -rf "$TMPDIR"
		