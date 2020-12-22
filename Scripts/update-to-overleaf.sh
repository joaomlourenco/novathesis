#!/bin/bash

####################################################################
# UPDATE NOVATHESIS TO OVERLEAF REPOSITORY
####################################################################

type wget >& /dev/null && GETCMD="wget -q -O"
type curl >& /dev/null && GETCMD="curl -L -s -o"
type unzip >& /dev/null && UNZIPCMD="unzip"
type git >& /dev/null && GITCMD="git"


if [[ -z "$UNZIPCMD" ]]; then
	echo "Did not find 'unzip' in your computer! Aborting..."
	exit 1
fi
if [[ -z "$GETCMD" ]]; then
	echo "Did not find neither 'curl' nor 'wget' in your computer! Aborting..."
	exit 1
fi
if [[ -z "$GITCMD" ]]; then
	echo "Did not find 'git' in your computer! Aborting..."
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


while getopts ":qkls:g:t:" opt; do
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
# echo "Renaming 'template.tex' to 'main.tex' due to Overleaf preference"
# mv -f template.tex main.tex	# Overleaf prefers "main.tex" as main file
echo "Removing unnecessary files"
rm -rf Scripts Examples _config.yml template.pdf

# Patch files
echo 'Patching "quote.tex", "dedicatory.tex" and "acknowledgements.tex"'
for i in quote dedicatory acknowledgements; do
	if [[ -f "Chapters/$i.tex" ]]; then
		perl -pi -e "s,\\\\end$i,\\\\end{nt$i}," Chapters/$i.tex
		perl -pi -e "s,\\\\$i,\\\\begin{nt$i}," Chapters/$i.tex
	fi
done
if [[ -f Chapters/acknowledgements.tex ]]; then
	fgrep "\end{ntacknowledgements}" Chapters/acknowledgements.tex || echo "\\end{ntacknowledgements}" >> Chapters/acknowledgements.tex
fi

# Import info fromtemplate-OLD.tex or from main-OLD.tex??
# if [[ -f template-OLD.tex && fgrep -q novathesis template-OLD.tex ]]; then
# 	INFILE=template-OLD.tex
# fi
# if [[ -f main-OLD.tex && fgrep -q novathesis main-OLD.tex ]]; then
# 	if [[ -n "$INFILE" ]]; then
# 		echo 'Found novathesis in both "template-OLD.tex" and "main-OLD.tex"!  Using info from "main-OLD.tex"'
# 	fi
# 	INFILE=main-OLD.tex
# fi
# if [[ -f template.tex ]]; then
# 	OUTFILE=template.tex
# fi
# if [[ -f main.tex ]]; then
# 	if [[ -n "$INFILE" ]]; then
# 		echo 'Found novathesis in both "template.tex" and "main.tex"!  Using info from "main.tex"'
# 	fi
# 	OUTFILE=main.tex
# fi
#
# echo "Patching \"$OUTFILE\" with info from \"$INFILE\""
# CLASS_OPTIONS_TO_IMPORT="docdegree school lang printcommittee"
# echo "Importing class options [$OPTIONS_TO_IMPORT]"
# for i in $CLASS_OPTIONS_TO_IMPORT; do
# 	INREGEX="^\s*($i)=([^ ,]*).*$"
# 	# OUTREGEX="\\\\ntsetup{$i=$VAL"
# 	OPT=$i
# 	VAL=$(cat $INFILE | perl -ne "s/$INREGEX/\2/ and print $1")
# 	echo Activating $OPT=$VAL...
# 	perl -pi -e "s|%* *\\\\ntsetup{$i=.*}|\\\\ntsetup{$i=$VAL}|" $OUTFILE
# done
#
# RX_NAME="title";	RX_INF_IN="^\\\\title(\[(.*)\])?{(.*)}\s$>";	RX_OUTF_IN]="";	 RX_OUTF_OUT=""
# for i in {1..20}; do
# 	VAR=REGEX$i
# 	echo $VAR=${REGEX1[name]}
# done
#
#
#
# TITLE=$(grep "^\\\\\<title\>" $INFILE | perl -p -e "s|^\\\\title\[(.*)\].*|\1|")
# [[ -z "$TITLE" ]] && TITLE=$(grep "^\\\\\<title\>" $INFILE | perl -p -e "s|^\\\\title.*{(.*)}|\1|")
# if [[ -n "$TITLE" ]]; then
# 	echo Setting title to [$TITLE]
# 	TITLE=$(echo $TITLE | perl -p -e 's/\\/\\\\/g')
# 	perl -pi -e "s|^%* *\\\\nttitle{.*}|\\\\nttitle{$TITLE}|" main.tex
# fi
# AUTHOR=$(grep "^\\\\\<authorname\>" $INFILE)
# if [[ -n "$AUTHOR" ]]; then
# 	AUTHORGENDER=$(fgrep "\authorname" $INFILE | perl -p -e "s/\\\\authorname\[(.)\].*/\1/")
# 	AUTHORLONGNAME=$(fgrep "\authorname" $INFILE | perl -p -e "s/\\\\authorname\[.\]{(.*)}{.*}/\1/")
# 	AUTHORSHORTNAME=$(fgrep "\authorname" $INFILE | perl -p -e "s/\\\\authorname\[.\]{.*}{(.*)}/\1/")
# 	echo Setting author info to [$AUTHORGENDER] [$AUTHORLONGNAME] [$AUTHORLONGNAME]
# 	perl -pi -e "s/%* *\\\\ntauthorname\[.\]{.*}{.*}/\\\\ntauthorname[$AUTHORGENDER]{$AUTHORLONGNAME}{$AUTHORLONGNAME}/" main.tex
# fi
# AUTHORDEGHREE=$(grep "^\\\\\<authordegree\>" $INFILE | cut -d '{' -f 2 | cut -d '}' -f 1)
# if [[ -n "$AUTHORDEGHREE" ]]; then
# 	echo Setting author degree info to [$AUTHORDEGHREE]
# 	perl -pi -e "s/%* *\\\\ntauthordegree{(.*)}/\\\\ntauthordegree{$AUTHORDEGHREE}/" main.tex
# fi
#
# echo Remember to setup manually the biblatex options...
#
# if [[ -z "$LOCAL" ]]; then
# 	echo "Committing and pushing new version"
# 	git add -A .					# Add all files to git
# 	V=$(fgrep "%% Version" main.tex | cut -d '[' -f 2 | cut -d ']' -f 1)
# 	git commit $QUIET -m "Updated template NOVAthesis to version $V"
# 	git push
# fi
cd ..

# Clean temp directory
cd ..
if [[ -n "$KEEP" ]]; then
	echo "Keeping Overleaf repository /$OVNAME"
	mv $UPDTMPDIR/$OVNAME .
fi
rm -rf "$UPDTMPDIR"
