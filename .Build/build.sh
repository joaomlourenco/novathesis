#!/usr/bin/env bash

MAKE=$(which gmake)
[[ -n "$MAKE" ]] || MAKE=make

CONF=Config/1_novathesis.tex

# save the config file
cp ${CONF} ${CONF}.OLD

# select options for showcase PDF: final phd document form FCT-NOVA, with final index (_índice remissivo_) and trimed book spine
perl -pi -e "s,.*\\\\ntsetup{doctype=.*},\\\\ntsetup{doctype=phd}," $CONF
perl -pi -e "s,.*\\\\ntsetup{school=.*},\\\\ntsetup{school=nova/fct}," $CONF
perl -pi -e "s,.*\\\\ntsetup{docstatus=.*},\\\\ntsetup{docstatus=final}," $CONF
perl -pi -e "s,.*\\\\ntsetup{spine=.*},\\\\ntsetup{spine=trim}," $CONF
perl -pi -e "s,.*\\\\ntsetup{printindex=.*},\\\\ntsetup{printindex=true}," $CONF

# build the PDF
$MAKE

# restore defaults
mv ${CONF}.OLD ${CONF}
