#!/bin/bash

####################################################################
# UPDATE NOVATHESIS TO OVERLEAF REPOSITORY
####################################################################

type wget >& /dev/null && GETCMD="wget -q -O"
type curl >& /dev/null && GETCMD="curl -L -s -o"
type unzip >& /dev/null && UNZIPCMD="unzip"


if [ -z "$UNZIPCMD" ]; then
	echo "Did not find 'unzip' command! Aborting..."
	exit
fi
if [ -z "$GETCMD" ]; then
	echo "Did not find 'curl' neither 'wget' commands! Aborting..."
fi


#===================================================================
# Main configuration variables
#===================================================================
# NTURL="https://github.com/joaomlourenco/novathesis.git"
NTURL="https://github.com/joaomlourenco/novathesis/zipball/master"


#===================================================================
# Process command line arguments
#===================================================================
function usage() {
	echo 'Usage: $(basename $0) [-k] [-g github_url] [-s school] <overleaf_url>'
	echo "-k            keep Overleaf repository"
	echo "-g <URL>      alternative URL for the base NOVAthesis repository"
	echo "-s <school>   remove definitions for all schools except '<school>'"
	exit 1
}


while getopts ":g:s:k" opt; do
  case ${opt} in
  	k ) # process option k
  		KEEP="true"
  		;;
	s ) # process option s
		SCHOOL="$OPTARG"
		;;
    g ) # process option g
		NTURL="$OPTARG"
		;;
  esac
done
shift $((OPTIND -1))

[[ -z "$1" || -n "$2" ]] && usage

OLURL=$1

TMPDIR="$(mktemp -d ./temp.XXXXXX)"

# Clone repositories in parallel
echo Cloning repositories
cd "$TMPDIR"
NTNAME="novathesis"
OLNAME="$(echo $OLURL | sed -e 's,.*/,,')"
[ -d "$OLNAME" ] || git clone --quiet "$OLURL"&
[ -d "$NTNAME" ] || ($GETCMD $NTNAME.zip https://github.com/joaomlourenco/novathesis/zipball/master && unzip -qq novathesis.zip && mv joaomlourenco-novathesis-* $NTNAME)&
wait

# DO NOT overwrite important files
cd $NTNAME
if [ -d ../$OLNAME/Chapters ]; then		# If it is an update
	echo "Folder 'Chapters' detected in Overleaf repository!  Preserving both 'Chapters' and 'bibliography.bib'..."
	rm -rf Chapters						# do not overwrite Chapters from user
	rm -f bibliography.bib				# do not overwrite user's bibliography
fi
rm -f template.pdf						# do not upload template.pdf
cd ..

# Clean unused novathesis schools if -s is given
if [ -n "$SCHOOL" ]; then
	echo "Removing all schools except $SCHOOL"
	cd $NTNAME
	SD=$(dirname $SCHOOL)
	SF=$(basename $SCHOOL)
	mv NOVAthesisFiles/Schools/$SCHOOL .	# save school's conf files to keep
	rm -rf NOVAthesisFiles/Schools			# remove all school's conf fires
	mkdir -p NOVAthesisFiles/Schools/$SD
	mv ./$SF NOVAthesisFiles/Schools/$SD	# restore saveed school's conf files
	cd ..
fi

# Clean onverleaf directory
cd $OLNAME
if [ -f template.tex ]; then
	echo "Saving 'template.tex' as 'template-OLD.tex'"
	mv -f template.tex template-OLD.tex
fi
if [ -f main.tex ]; then
	echo "Saving 'main.tex' as 'main-OLD.tex'"
	mv -f main.tex main-OLD.tex
fi
echo "Deleting old template files"
ls | fgrep -v -e Chapters -e bibliography.bib -e *-OLD.tex | xargs git rm --quiet -rf
echo "Restoring new template files"
mv ../$NTNAME/* .		# get files from NOVAthesis folder
echo "Renaming 'template.tex' to 'main.tex' due to Overleaf preference"
mv -f template.tex main.tex	# Overleaf prefers "main.tex" as main file
echo "Removing unnecessary files"
rm -rf Scripts Examples _config.yml template.pdf
echo "Committing and pushing new version"
git add -A .					# Add all files to git
V=$(fgrep "%% Version" main.tex | cut -d '[' -f 2 | cut -d ']' -f 1)
git commit --quiet -m "Updated template NOVAthesis to version $V"
git push
cd ..

# Clean temp directory
cd ..
if [ -n "$KEEP" ]; then
	echo "Keeping Overleaf repository /$OLNAME"
	mv $TMPDIR/$OLNAME .
fi
rm -rf "$TMPDIR"
