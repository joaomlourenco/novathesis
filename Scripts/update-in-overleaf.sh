#!/bin/bash

#===================================================================
# Main configuration variables
#===================================================================
NTURL="https://github.com/joaomlourenco/novathesis.git"


#===================================================================
# Process command line arguments
#===================================================================
function usage() {
	echo 'Usage: ${basename $0} [-k] [-g github_url] [-s school] <overleaf_url>'
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

# Clean unused novathesis schools if -s is given
if [ -n "$SCHOOL" ]; then
	cd $NTNAME
	SD=$(dirname $SCHOOL)
	SF=$(basename $SCHOOL)
	rm -rf Chapters							# do not overwrite Chapters from user
	mv NOVAthesisFiles/Schools/$SCHOOL .	# save school's conf files to keep
	rm -rf NOVAthesisFiles/Schools			# remove all school's conf fires
	mkdir -p NOVAthesisFiles/Schools/$SD
	mv ./$SF NOVAthesisFiles/Schools/$SD	# restore saveed school's conf files
	rm -f template.pdf						# remove template.pdf if exists
	rm -f bibliography.bib					# do not overwrite user's bibliography
	cd ..
fi

# Clean onverleaf directory
cd $OLNAME
read a
[ -f template.tex ] && mv -f template.tex template-OLD.tex
read a
[ -f main.tex ] && mv -f main.tex main-OLD.tex
read a
ls | fgrep -v -e Chapters -e bibliography.bib -e *-OLD.tex | xargs git rm -rf
# find . -type d | grep -v -e '^.$' -e '/.git' -e 'Chapters' | while read i; do git rm -rf "$i"; done
read a
mv ../$NTNAME/* .		# get files from NOVAthesis folder
read a
mv -f template.tex main.tex	# Overleaf prefers "main.tex" as main file
read a
rm -f _config.yml template.pdf
read a
rm -rf Scripts Examples
read a
git add -A .					# Add all files to git
read a
V=$(fgrep "%% Version" main.tex | cut -d '[' -f 2 | cut -d ']' -f 1)
git commit -m "Updated template NOVAthesis to version $V"
read a
git push
cd ..

# Clean temp directory
cd ..
if [ -n "$KEEP" ]; then
	mv $TMPDIR/$OLNAME .
fi
rm -rf "$TMPDIR"
		