#!/bin/bash

####################################################################
# UPDATE NOVATHESIS IN GIT REPOSITORY
####################################################################

#===================================================================
# CHECK FOR NECESSARY COMMANDS
#===================================================================
type wget >& /dev/null && GET="wget -q -O"
type curl >& /dev/null && GET="curl -L -s -o"
type unzip >& /dev/null && UNZIP="unzip"
type tr >& /dev/null && TR="tr"
type cut >& /dev/null && CUT="cut"
type perl >& /dev/null && PERL="perl"
type git >& /dev/null && GIT="git"


if [[ -z "$UNZIP" ]]; then
	echo "Did not find 'unzip' in your computer! Aborting..."
	exit 1
fi
if [[ -z "$GET" ]]; then
	echo "Did not find neither 'curl' nor 'wget' in your computer! Aborting..."
	exit 1
fi
if [[ -z "$TR" ]]; then
	echo "Did not find 'tr' in your computer! Aborting..."
	exit 1
fi
if [[ -z "$CUT" ]]; then
	echo "Did not find 'cut' in your computer! Aborting..."
	exit 1
fi
if [[ -z "$PERL" ]]; then
	echo "Did not find 'perl' in your computer! Aborting..."
	exit 1
fi
if [[ -z "$GIT" ]]; then
	echo "Did not find 'git' in your computer! Aborting..."
	exit 1
fi


#===================================================================
# MAIN CONFIGURATION VARIABLES
#===================================================================
# NTURL="https://github.com/joaomlourenco/novathesis.git"
ZIPURL="https://github.com/joaomlourenco/novathesis/zipball/master"
OVBASE="https://git.overleaf.com"


#===================================================================
# PROCESS COMMAND LINE ARGUMENTS
#===================================================================
function usage() {
	echo "Usage: $(basename $0) [-q] [-k] [-l] [-s school] [-p] [-f] [-z url] [-t temp_dir] <repo_url>"
	echo "-q            quiet/silent operation"
	echo "-k            keep Overleaf repository"
	echo "-l            stay local and do not upload commit to Overleaf (implies -k)"
	echo "-s <school>   keep only <school> and remove definitions for all the other schools"
	echo "-p            main patching (safe)"
	echo "-f            fine patching (dangerous)"
	echo "-r			skip download!"
	echo "-z <URL>      alternative URL for the base NOVAthesis repository"
	echo "-t <dir>      use <temp-dir> as a temporary directory"
	echo "<repo_url>    repository to be updated (if not a complete URL defaults to Overleaf)"
	exit 1
}

while getopts ":qkls:pfrz:t:" opt; do
  case ${opt} in
	q ) # quiet/silent operation
			QUIET="--quiet"
			;;
	k ) # keep Overleaf repository
			KEEP="true"
			;;
	l ) # stay local and do not upload commit to Overleaf (implies -k)
			KEEP="true"
			LOCAL="true"
	  		;;
	s ) # keep only <school> and remove definitions for all the other schools
			SCHOOL="$OPTARG"
			;;
	p ) # main patching (safe)
			PATCH="true"
			;;
	f ) # fine patching (dangerous)
			FINEPATCH="true"
			;;
	r ) # retry… skip download! 
			RETRY="true"
			;;
	z ) # alternative URL for the base NOVAthesis repository
			ZIPURL="$OPTARG"
			;;
	t ) # use <temp-dir> as a temporary directory
			UPDTMPDIR="$OPTARG"
			;;
  esac
done
shift $((OPTIND -1))


#============================================================
# DOWNLOADING
#============================================================
if [[ -z "$RETRY" ]]; then

	# must have one and only one paramenter
	[[ $# -eq 1 ]] || usage

	if [[ $1 =~ "/" ]]; then
		REPOURL=$1
	else
		REPOURL=$OVBASE/$1
	fi

	echo Getting NOVAthesis from: $ZIPURL
	echo Updating repository at: $REPOURL

	if [[ -z "$UPDTMPDIR" ]]; then
		UPDTMPDIR="$(mktemp -d ./temp.XXXXXX)"
	fi
	echo Using temporary directory: $UPDTMPDIR

	cd "$UPDTMPDIR"

	# Cloning repository in parallel with downloading ZIP file
	echo Downloading…
	
	# Cloning/updating the user repository
	REPO="$(echo $REPOURL | sed -e 's,.*/,,' -e 's/\.git$//')"
	if [[ ! -d "$REPO" ]]; then
		git clone $QUIET "$REPOURL"&
		CLONEPID=$!
	else
		git pull $QUIET&
		CLONEPID=$!
	fi

	# Download the novathesis template as a ZIP
	NTDIR="novathesis"
	if [[ ! -f "$NTDIR.zip" ]]; then
		$GET $NTDIR.zip $ZIPURL
		if [[ $? -ne 0 ]]; then
			echo "Error getting NOVAthesis from $ZIPURL!  Aborting..."
			exit 1
		fi
	fi
	if [[ ! -d "$NTDIR" ]]; then
		$UNZIP -qq $NTDIR.zip
		mv joaomlourenco-novathesis-* $NTDIR
	fi

	# Wait for clone operation to finish
	if ! wait $CLONEPID; then
		# echo $(pwd)
		echo "Error getting Overleaf project from $REPOURL!  Aborting..."
		exit 1
	fi

	#============================================================
	# For safety make a copy of user's repo
	cp -r $REPO new-$REPO

	#============================================================
	cd new-$REPO

	#============================================================
	# Remove “novathesis-files” and replace with “NOVAthesisFiles”
	echo Getting the new “NOVAthesisFiles”
	cp -r ../$NTDIR/NOVAthesisFiles .

	# Get remainder of relevant files
	echo "Getting 'novathesis.cls'"
	cp ../$NTDIR/novathesis.cls .
	TVER=$(fgrep Version template.tex  | $CUT -d '[' -f 2 | $CUT -d '.' -f 1)
	case "$TVER" in
		4)	echo "v4.x of 'template.tex' found!  Saving it in 'template-ORIG.tex' and getting new version"
			mv texmplate.tex texmplate-ORIG.tex  &&  cp ../$NTDIR/template.tex .
			;;
		5)	echo "v5.x of 'template.tex' found!  Keeping it and saving new version as 'template-NEW.tex'"
			cp ../$NTDIR/template.tex ./template-NEW.tex
			;;
		*)	echo "'template.tex' not found or invalid version!  Aborting..."
			exit 1
			;;
	esac
	
	# Clean legacy files
	rm -rf novathesis-files Examples LICENSE README.md Scripts/ changelog.txt template.tdf main.pdf dissertation.pdf 

fi # -z "$RETRY"

#============================================================
# CLWAN SCHOOLS
#============================================================
# Clean unused novathesis schools if -s is given
if [[ -n "$SCHOOL" ]]; then
	
	# Validate school
	if [[ ! -d "NOVAthesisFiles/Schools/$SCHOOL" ]]; then
		echo "Invalid school: $SCHOOL!  Aborting..."
		exit 1
	fi	
	echo "Removing all schools except $SCHOOL"
	SD=$(dirname $SCHOOL)
	SF=$(basename $SCHOOL)
	# save school's conf files to keep and delete others
	mv NOVAthesisFiles/Schools/$SCHOOL .	
	rm -rf NOVAthesisFiles/Schools
	# restore saveed school's conf files
	mkdir -p NOVAthesisFiles/Schools/$SD
	mv ./$SF NOVAthesisFiles/Schools/$SD

fi # -n "$SCHOOL"


#============================================================
# PATCHING FILES from 4.x to 5.x (safe operation)
#============================================================
if [[ -n "$PATCH" ]]; then

	#============================================================
	# Patch begin/end in files ”quote”, ”dedicatory” and “acknowledgements”
	echo 'Patching “quote.tex”, “dedicatory.tex” and “acknowledgements.tex”'
	for i in quote dedicatory acknowledgements; do
		if [[ -f "Chapters/$i.tex" ]]; then
			$PERL -pi -e "s,\\\\end$i,\\\\end{nt$i}," Chapters/$i.tex
			$PERL -pi -e "s,\\\\$i,\\\\begin{nt$i}," Chapters/$i.tex
		fi
	done
	if [[ -f Chapters/acknowledgements.tex ]]; then
		fgrep "\end{ntacknowledgements}" Chapters/acknowledgements.tex || ( (echo; echo "\\end{ntacknowledgements}") >> Chapters/acknowledgements.tex)
	fi
	
fi # "$$PATCH" = "true"


#============================================================
# FINE PATCHING FILES - part 1 (template.tex)
#============================================================
INFILE=template-ORIG.tex
OUTFILE=template.tex

if [[ -n "$FINEPATCH" && -f "$INFILE" ]]; then 

	TVER=$(fgrep Version $INFILE  | $CUT -d '[' -f 2 | $CUT -d '.' -f 1)
	case "$TVER" in
		4)	echo "v4.x found in $INFILE!  Patching!"
			;;
		5)	echo "v5.x found in $INFILE!  Skipping!"
			FINEPATCH=""
			;;
		*)	echo "'template.tex' not found or invalid version!  Aborting..."
			exit 1
			;;
	esac
fi

#============================================================
# FINE PATCHING FILES - part 2 (template.tex)
#============================================================
if [[ -n "$FINEPATCH" ]]; then 							
	
	#------------------------------------------------------------
	# Patching template.tex from template-ORIG.tex
	INFILE=template-ORIG.tex
	OUTFILE=template.tex
	echo "Fine patching ($INFILE => $OUTFILE)"
	
	#------------------------------------------------------------
	# Patch the class options
	CLASS_OPTIONS_TO_IMPORT="docdegree school lang printcommittee"
	# echo "Importing class options [$CLASS_OPTIONS_TO_IMPORT]"
	for i in $CLASS_OPTIONS_TO_IMPORT; do
		INREGEX="^\s*($i)=([^ ,]*).*$"
		# OUTREGEX="\\\\ntsetup{$i=$VAL"
		OPT=$i
		VAL=$(cat $INFILE | $PERL -ne "s/$INREGEX/\2/ and print $1")
		echo "Option $OPT=$VAL..."
		$PERL -pi -e "s|%* *\\\\ntsetup\{$i=.*\}|\\\\ntsetup\{$i=$VAL\}|" $OUTFILE
	done
	
	#------------------------------------------------------------
	# Patch the title
	TITLE=$(grep "^\\\\\<title\>" $INFILE | $PERL -p -e "s|^\\\\title\[(.*)\].*|\1|")
	[[ -z "$TITLE" ]] && TITLE=$(grep "^[^%]*\\\\\<title\>" $INFILE | $PERL -p -e "s|^\\\\title.*\{(.*)\}|\1|")
	if [[ -n "$TITLE" ]]; then
		echo Setting title=$TITLE
		TITLE=$(echo $TITLE | $PERL -p -e 's/\\/\\\\/g')
		$PERL -pi -e "s|^%* *\\\\nttitle\{.*\}|\\\\nttitle\{$TITLE\}|" $OUTFILE
	fi

	#------------------------------------------------------------
	# Patching: majorfield, specialization
	ALLTARGETS="majorfield specialization"
	for TARGET in $ALLTARGETS; do
		grep "^[^%]*\\\\\<${TARGET}\>" $INFILE | 
			$PERL -pe "s|.*\\${TARGET}\[(.*)\]=\{(.*)\}|\1\t\2|" |
				while read l m; do
					echo "Setting $TARGET($l)=$m"
					$PERL -pi -e "s|^\\\\nt${TARGET}\($l\)\{.*\}|\\\\nt${TARGET}\($l\)\{$m\}|" $OUTFILE
				done
	done

	#------------------------------------------------------------
	# Patching: authorname, authordegree, datemonth, dateyear
	ALLTARGETS="authorname authordegree datemonth dateyear"
	for TARGET in $ALLTARGETS; do
		VAL=$(grep "^[^%]*\\\\\<${TARGET}\>" $INFILE | $PERL -pe "s|\\\\\b${TARGET}\b(.*)|\1|")
		echo "Setting $TARGET=$VAL"
		$PERL -pi -e "s|^\\\\nt${TARGET}.*|\\\\nt${TARGET}${VAL}|" $OUTFILE
	done

	#------------------------------------------------------------
	# Patching: adviser, coadviser
	ALLTARGETS="adviser coadviser"
	for TARGET in $ALLTARGETS; do
		grep "^[^%]*\\\\\<${TARGET}\>" $INFILE | $PERL -pe "s|\\\\\b${TARGET}\b(.*)|\1|; s|\}\{|, |g; s,\\\\|&,,g" | 
			while read n; do
				echo "Setting $TARGET=$n"
				$PERL -i -pe "\$done||= s|^.*\\\\ntaddperson\{${TARGET}\}.*Adviser Name.*|\\\\ntaddperson\{${TARGET}\}$n|" $OUTFILE
			done
	done

	#------------------------------------------------------------
	# Patching abstract 
	ALLTARGETS="abstract"
	for TARGET in $ALLTARGETS; do
		CHAPTARGETREGEX="(%\s*syntax:\s+\\\\ntaddfile\{${TARGET}\}.*)"
		CHAPBASEREGEX="(%\s*)?\\\\ntaddfile\{${TARGET}\}.*\n"
		VAL=($(fgrep "${TARGET}file" $INFILE | grep -v '^%' | $PERL -pe "s/\\\\${TARGET}file\[(.*)\]\{(.*)\}.*/\1+\2/" | xargs))
		len=${#VAL[@]}
		# echo $TARGET $len
		# remove example block
		$PERL -pi -e "s/^${CHAPBASEREGEX}//" $OUTFILE
		# add new block
		for (( i=$len-1; i>=0; i-- )); do
			echo "Adding ${TARGET}=${VAL[$i]}"
			L=$(echo ${VAL[$i]} | cut -d '+' -f 1)
			F=$(echo ${VAL[$i]} | cut -d '+' -f 2)
			$PERL -pi -e "s/^${CHAPTARGETREGEX}/\1\n\\\\ntaddfile\{${TARGET}\}\[$L\]\{$F\}/" $OUTFILE
		done
	done

	#------------------------------------------------------------
	# Patching glossaries
	ALLTARGETS="glossary acronyms symbols"
	for TARGET in $ALLTARGETS; do
		CHAPTARGETREGEX="(%\s*syntax:\s+\\\\ntaddfile\{glossaries\}.*)"
		CHAPBASEREGEX="(%\s*)?\\\\ntaddfile\{glossaries\}\[${TARGET}\].*\n"
		VAL=($(fgrep "${TARGET}file" $INFILE | grep -v '^%' | $PERL -pe "s/\\\\${TARGET}file\{(.*)\}.*/\1/" | xargs))
		len=${#VAL[@]}
		# echo $TARGET $len
		# remove example block
		$PERL -pi -e "s/^${CHAPBASEREGEX}//" $OUTFILE
		# add new block
		for (( i=$len-1; i>=0; i-- )); do
			echo "Adding ${TARGET}=${VAL[$i]}"
			$PERL -pi -e "s/^${CHAPTARGETREGEX}/\1\n\\\\ntaddfile\{glossaries\}\[${TARGET}\]\{${VAL[@]}\}/" $OUTFILE
		done
	done

	#------------------------------------------------------------
	# Patching chapter, appendix, annex, aftercover
	ALLTARGETS="chapter appendix annex aftercover"
	for TARGET in $ALLTARGETS; do
		CHAPTARGETREGEX="(%\s*syntax:\s+\\\\ntaddfile\{${TARGET}\}.*)"
		CHAPBASEREGEX="(%\s*)?\\\\ntaddfile\{${TARGET}\}.*\n"
		VAL=($(fgrep "\\${TARGET}file" $INFILE | fgrep -v "%" | cut -d '{' -f 2 | cut -d '}' -f 1 | xargs))
		len=${#VAL[@]}
		# remove example block
		$PERL -pi -e "s/^${CHAPBASEREGEX}//" $OUTFILE
		# add new block
		for (( i=$len-1; i>=0; i-- )); do
			echo "Adding ${TARGET}=${VAL[$i]}"
			$PERL -pi -e "s/^${CHAPTARGETREGEX}/\1\n\\\\ntaddfile\{${TARGET}\}\{${VAL[$i]}\}/" $OUTFILE
		done
	done

	#------------------------------------------------------------
	# Patching bib
	ALLTARGETS="bib"
	for TARGET in $ALLTARGETS; do
		CHAPTARGETREGEX="(%\s*syntax:\s+\\\\ntaddfile\{${TARGET}\}.*)"
		CHAPBASEREGEX="(%\s*)?\\\\ntaddfile\{${TARGET}\}.*\n"
		VAL=($(fgrep "\\add${TARGET}file" $INFILE | fgrep -v "%" | cut -d '{' -f 2 | cut -d '}' -f 1 | xargs))
		len=${#VAL[@]}
		# remove example block
		$PERL -pi -e "s/^${CHAPBASEREGEX}//" $OUTFILE
		# add new block
		for (( i=$len-1; i>=0; i-- )); do
			echo "Adding ${TARGET}=${VAL[$i]}"
			$PERL -pi -e "s/^${CHAPTARGETREGEX}/\1\n\\\\ntaddfile\{${TARGET}\}\{${VAL[$i]}\}/" $OUTFILE
		done
	done
	
	
fi # -n "$FINEPATCH"

#============================================================
# Cleaning up
#============================================================
if [[ -n "$LOCAL" ]]; then
	echo Keeping local... exiting!
	exit 0
fi

cd ../..

if [[ -n "$KEEP" ]]; then
	echo "Keeping USER's repository $REPO"
	mv $UPDTMPDIR/$REPO .
fi
rm -rf "$UPDTMPDIR"

exit







# echo "Patching \"$OUTFILE\" with info from \"$INFILE\""
# CLASS_OPTIONS_TO_IMPORT="docdegree school lang printcommittee"
# echo "Importing class options [$OPTIONS_TO_IMPORT]"
# for i in $CLASS_OPTIONS_TO_IMPORT; do
# 	INREGEX="^\s*($i)=([^ ,]*).*$"
# 	# OUTREGEX="\\\\ntsetup{$i=$VAL"
# 	OPT=$i
# 	VAL=$(cat $INFILE | $PERL -ne "s/$INREGEX/\2/ and print $1")
# 	echo Activating $OPT=$VAL...
# 	$PERL -pi -e "s|%* *\\\\ntsetup{$i=.*}|\\\\ntsetup{$i=$VAL}|" $OUTFILE
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
# TITLE=$(grep "^\\\\\<title\>" $INFILE | $PERL -p -e "s|^\\\\title\[(.*)\].*|\1|")
# [[ -z "$TITLE" ]] && TITLE=$(grep "^\\\\\<title\>" $INFILE | $PERL -p -e "s|^\\\\title.*{(.*)}|\1|")
# if [[ -n "$TITLE" ]]; then
# 	echo Setting title to [$TITLE]
# 	TITLE=$(echo $TITLE | $PERL -p -e 's/\\/\\\\/g')
# 	$PERL -pi -e "s|^%* *\\\\nttitle{.*}|\\\\nttitle{$TITLE}|" main.tex
# fi


# AUTHOR=$(grep "^\\\\\<authorname\>" $INFILE)
# if [[ -n "$AUTHOR" ]]; then
# 	AUTHORGENDER=$(fgrep "\authorname" $INFILE | $PERL -p -e "s/\\\\authorname\[(.)\].*/\1/")
# 	AUTHORLONGNAME=$(fgrep "\authorname" $INFILE | $PERL -p -e "s/\\\\authorname\[.\]{(.*)}{.*}/\1/")
# 	AUTHORSHORTNAME=$(fgrep "\authorname" $INFILE | $PERL -p -e "s/\\\\authorname\[.\]{.*}{(.*)}/\1/")
# 	echo Setting author info to [$AUTHORGENDER] [$AUTHORLONGNAME] [$AUTHORLONGNAME]
# 	$PERL -pi -e "s/%* *\\\\ntauthorname\[.\]{.*}{.*}/\\\\ntauthorname[$AUTHORGENDER]{$AUTHORLONGNAME}{$AUTHORLONGNAME}/" main.tex
# fi
# AUTHORDEGHREE=$(grep "^\\\\\<authordegree\>" $INFILE | cut -d '{' -f 2 | cut -d '}' -f 1)
# if [[ -n "$AUTHORDEGHREE" ]]; then
# 	echo Setting author degree info to [$AUTHORDEGHREE]
# 	$PERL -pi -e "s/%* *\\\\ntauthordegree{(.*)}/\\\\ntauthordegree{$AUTHORDEGHREE}/" main.tex
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
	echo "Keeping Overleaf repository /$REPO"
	mv $UPDTMPDIR/$REPO .
fi
rm -rf "$UPDTMPDIR"
