#!/bin/bash

####################################################################
# UPDATE NOVATHESIS TO OVERLEAF REPOSITORY
####################################################################

type wget >& /dev/null && GETCMD="wget -q -O"
type curl >& /dev/null && GETCMD="curl -L -s -o"
type unzip >& /dev/null && UNZIPCMD="unzip"


if [[ -z "$UNZIPCMD" ]]; then
	echo "Did not find 'unzip' command! Aborting..."
	exit 1
fi
if [[ -z "$GETCMD" ]]; then
	echo "Did not find 'curl' neither 'wget' commands! Aborting..."
	exit 1
fi


#===================================================================
# Main configuration variables
#===================================================================
# NTURL="https://github.com/joaomlourenco/novathesis.git"
NTURL="https://github.com/joaomlourenco/novathesis/zipball/master"
OVBASE="https://git.overleaf.com"

#===================================================================
# Process command line arguments
#===================================================================
function usage() {
	echo "Usage: $(basename $0) [-q] [-k] [-l] [-s school] [-g github_url] [-t temp_dir] <overleaf_url>"
	echo "-q            quiet/silent operation"
	echo "-k            keep Overleaf repository"
	echo "-l            stay local and do not upload commit to Overleaf (implies -k)"
	echo "-g <URL>      alternative URL for the base NOVAthesis repository"
	echo "-s <school>   remove definitions for all schools except '<school>'"
	echo "-t <temp-dir> use <temp-dir> as a temporary directory"
	exit 1
}


while getopts ":qks:g:t:" opt; do
  case ${opt} in
	q ) # process option q
		QUIET="--quiet"
		;;
  	k ) # process option k
  		KEEP="true"
  		;;
  	l ) # process option k
  		KEEP="true"
		LOCAL="true"
  		;;
	s ) # process option s
		SCHOOL="$OPTARG"
		;;
    g ) # process option g
		NTURL="$OPTARG"
		;;
    t ) # process option t
		UPDTMPDIR="$OPTARG"
		;;
  esac
done
shift $((OPTIND -1))

# must have one and only one paramenter

[[ -z "$1" || -n "$2" ]] && usage

if [[ $1 =~ "^https://git.overleaf.com/" ]]; then
	OVURL=$1
else
	OVURL=$OVBASE/$1
fi

if [[ -z "$UPDTMPDIR" ]]; then
	UPDTMPDIR="$(mktemp -d ./temp.XXXXXX)"
fi
echo Using temporary directory: $UPDTMPDIR

# Clone repositories in parallel
echo Cloning repositories
cd "$UPDTMPDIR"
NTNAME="novathesis"
OVNAME="$(echo $OVURL | sed -e 's,.*/,,')"
if [[ ! -d "$OVNAME" ]]; then
	git clone $QUIET "$OVURL"&
	OVPID=$!
fi
if [[ ! -d "$NTNAME" ]]; then
	$GETCMD $NTNAME.zip $NTURL
	if [[ $? -ne 0 ]]; then
		echo "Error getting NOVAthesis from $NTURL!  Aborting..."
		exit 1
	fi
	unzip -qq novathesis.zip
	rm novathesis.zip
	mv joaomlourenco-novathesis-* $NTNAME
fi

if ! wait $OVPID; then
	echo $(pwd)
	echo "Error getting Overleaf project from $OVURL!  Aborting..."
	exit 1
fi
	

# DO NOT overwrite important files
cd $NTNAME
if [[ -d ../$OVNAME/Chapters ]]; then		# If it is an update
	echo "Folder 'Chapters' detected in Overleaf repository!  Preserving both 'Chapters' and 'bibliography.bib'..."
	rm -rf Chapters						# do not overwrite Chapters from user
	rm -f bibliography.bib				# do not overwrite user's bibliography
fi
rm -f template.pdf						# do not upload template.pdf

# Clean unused novathesis schools if -s is given
if [[ -n "$SCHOOL" ]]; then
	if [[ ! -d "NOVAthesisFiles/Schools/$SCHOOL" ]]; then
		echo "Invalid school: $SCHOOL!  Aborting..."
		exit 1
	fi	
	echo "Removing all schools except $SCHOOL"
	SD=$(dirname $SCHOOL)
	SF=$(basename $SCHOOL)
	mv NOVAthesisFiles/Schools/$SCHOOL .	# save school's conf files to keep
	rm -rf NOVAthesisFiles/Schools			# remove all school's conf fires
	mkdir -p NOVAthesisFiles/Schools/$SD
	mv ./$SF NOVAthesisFiles/Schools/$SD	# restore saveed school's conf files
fi
cd ..

# Clean onverleaf directory
cd $OVNAME
if [[ -f template.tex ]]; then
	echo "Saving 'template.tex' as 'template-OLD.tex'"
	mv -f template.tex template-OLD.tex
fi
if [[ -f main.tex ]]; then
	echo "Saving 'main.tex' as 'main-OLD.tex'"
	mv -f main.tex main-OLD.tex
fi
echo "Deleting old template files"
ls | fgrep -v -e Chapters -e bibliography.bib -e *-OLD.tex | xargs rm $QUIET -rf
echo "Restoring new template files"
mv ../$NTNAME/* .		# get files from NOVAthesis folder
echo "Renaming 'template.tex' to 'main.tex' due to Overleaf preference"
mv -f template.tex main.tex	# Overleaf prefers "main.tex" as main file
echo "Removing unnecessary files"
rm -rf Scripts Examples _config.yml template.pdf
echo "Committing and pushing new version"

if [[ -z "$LOCAL" ]]; then
	git add -A .					# Add all files to git
	V=$(fgrep "%% Version" main.tex | cut -d '[' -f 2 | cut -d ']' -f 1)
	git commit $QUIET -m "Updated template NOVAthesis to version $V"
	git push
fi

# Patch files
for i in quote dedicatory acknowledgements; do
	[[ -f "Chapters/$i.tex" ]] && perl -pi -e "s/\\$i/\\begin{nt$i}/" -e "s/\\end$i/\\end{nt$i}/" Chapters/$i.tex
done
cd ..

# Clean temp directory
cd ..
if [[ -n "$KEEP" ]]; then
	echo "Keeping Overleaf repository /$OVNAME"
	mv $UPDTMPDIR/$OVNAME .
fi
rm -rf "$UPDTMPDIR"
