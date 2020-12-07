#!/bin/bash

renice 20 $$

# should the output directory be deleted?
NOW=$(date "+%Y-%m-%d@%H-%M")
VERSION=$(fgrep "%% Version" template.tex | cut -d '[' -f 2 | cut -d ']' -f 1)
OUTDIR=../NT-OutputTests-v$VERSION
LOGFILE=$OUTDIR/log_$NOW.log
FORCE=false
DELETE=false
SET1=false
SET2=false

#===================================================================
# Process command line arguments
#===================================================================
args=`getopt fx12o: $*`
# you should not use `getopt abo: "$@"` since that would parse
# the arguments differently from what the set command below does.
if [ $? != 0 ]
then
        echo 'Usage: ...'
        exit 2
fi
set -- $args
# You cannot use the set command with a backquoted getopt directly,
# since the exit code from getopt would be shadowed by those of set,
# which is zero by definition.
for i; do
    case "$i" in
		-f)
            FORCE=true;
            shift;;
		-x)
            DELETE=true;
            shift;;
        -1)
                SET1=true;
                shift;;
        -2)
                SET2=true;
                shift;;
        -o)
                OUTDIR="$2"; shift;
                shift;;
        --)
                shift; break;;
    esac
done

#===================================================================
# DEFINITIONS
#===================================================================

processor="pdfxe pdflua pdf"
# %%------------------------------------------------------------
# %% THE MOST IMPORTANT/POPULAR OPTIONS
# %%------------------------------------------------------------
docdegree="phd phdplan phdprop msc mscplan bsc"
school="nova/fct nova/fcsh nova/ims nova/ensp ul/ist ul/fc ipl/isel ips/ests esep"
lang="pt en fr it"
linkscolor="SteelBlue Red"
media="screen paper"
printcommittee="true false"
secondcover="true false"
urlstyle="tt rm sf same"

# %%------------------------------------------------------------
# %% THE LESS IMPORTANT/POPULAR OPTIONS
# %%------------------------------------------------------------
fontstyle="kpfonts bookman libertine scholax calibri kieranhealy"
chapstyle="elegant bianchi bluebox default ell hansen ist lyhne madsen pedersen veelo vz34 vz43"
coverlang="pt en fr it"
copyrightlang="pt en fr it"
aftercover="true false"
# debugcover="true false"
# spine="true false"
# cdcover="true false"


if [ "$OUTDIR" = "ture" ]; then
	if [ "$FORCE" = "false" ]; then
		echo "Removing $OUTDIT if it exists!  Are you sure? (y/n)"
		read yn
	else
		yn=y
	fi
	if [ "$yn" = "y" ]; then
		rm -rf $OUTDIR
	fi
fi

#===================================================================
# TEST PRIMARY ATTRIBUTES
#===================================================================
if [ "$SET1" = "true" ]; then
	for i2 in "school"; do
		for school_ in ${!i2}; do
			for i1 in "docdegree"; do 
				for degree_ in ${!i1}; do
					cp template.tex main.tex
					rm main.aux
					perl -pi -e "s|^% \\\\ntsetup{$i2=(.*)}|\\\\ntsetup{$i2=$school_}|" main.tex
					perl -pi -e "s|^% \\\\ntsetup{$i1=(.*)}|\\\\ntsetup{$i1=$degree_}|" main.tex
					mkdir -p $OUTDIR/1/$school_
					for processor_ in $processor; do
						echo "=================================================================="
						echo "$i2=$school_ $i1=$degree_ $processor_"
						echo "=================================================================="
						latexmk -time -silent -$processor_ -interaction=nonstopmode main | tee -a  $LOGFILE
						[ -f main.xdv ] && xdvipdfmx -E -o main.pdf main.xdv && rm main.xdv
						[ -f main.pdf ] && mv main.pdf $OUTDIR/1/$school_/$degree_-$processor_.pdf
					done
				done
			done
		done
	done

	Scripts/latex-clean-temp.sh
	rm main.tex
	
fi # SET1


#===================================================================
# TEST SECONDRY ATTRIBUTES
#===================================================================
if [ "$SET2" = "true" ]; then
	mkdir -p $OUTDIR/2
	for i in lang linkscolor media urlstyle media printcommittee secondcover urlstyle fontstyle chapstyle; do
		for j in ${!i}; do
			echo "=================================================================="
			echo "Testing - $i=$j"
			echo "=================================================================="
			cp template.tex main.tex
			# perl -pi -e "s|^% \\\\ntsetup{school=(.*)}|\\\\ntsetup{school=nova/fct}|" main.tex
			perl -pi -e "s|^% \\\\ntsetup{$i=(.*)}|\\\\ntsetup{$i=$j}|" main.tex
			# fgrep ntsetup main.tex | fgrep -e "$i" -e "school"
			time latexmk -silent -pdf -interaction=nonstopmode main | tee -a $LOGFILE
			[ -f main.pdf ] && mv main.pdf $OUTDIR/2/$i-$j.pdf || touch $OUTDIR/2/$i-$j-FAILED.txt
		done
	done
	
	Scripts/latex-clean-temp.sh
	rm main.tex
	
fi # SET2
