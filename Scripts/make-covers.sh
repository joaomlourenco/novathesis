uminho=xe
esep=xe

NOW=$(date "+%Y-%m-%d@%H:%M:%S")
OUTDIR=$NOW/Covers

rm -rf OUTDIR

cp Config/1_novathesis.tex Config/1_novathesis.bak
for DEGREE in msc phd; do
    mkdir -p $OUTDIR/$DEGREE
    perl -pi -e "s-(%\s*)?\\\\ntsetup\{docDEGREE=.*\}-\\\\ntsetup{docDEGREE=${DEGREE}}-" Config/1_novathesis.tex
    find NOVAthesisFiles/Schools -type d -depth 2 | fgrep -v Images | cut -d '/' -f 3- | while read i; do
    	perl -pi -e "s-(%\s*)?\\\\ntsetup\{school=.*\}-\\\\ntsetup{school=$i}-" Config/1_novathesis.tex
        U=$(echo $i | cut -d '/' -f 1)
        S=$(echo $i | cut -d '/' -f 2)
        make ${!U} ${!S} FLAGS=-f SILENT=""
    	F=$(echo $i | tr '/' '-')
    	pdftk template.pdf cat 1 output $OUTDIR/$DEGREE/cover-$F-$DEGREE.pdf
    done
done 2>&1 | tee $OUTDIR/make-covers.log
mv -f Config/1_novathesis.bak Config/1_novathesis.tex
