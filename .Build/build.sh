#!/usr/bin/env bash
if [[ -z "$1" ]]; then
  echo "Missing univ/schl!"
  echo "Exiting…"
  exit 1
fi

set -e

MAKE=$(command -v gmake || command -v make)

CONF=Config/1_novathesis.tex

# select options for showcase PDF: final phd document form FCT-NOVA, with final index (_índice remissivo_) and trimed book spine
sed -i'.OLD' -e 's,.*\\ntsetup{doctype=.*},\\ntsetup{doctype=phd},' \
            -e "s,.*\\ntsetup{school=.*},\\ntsetup{school=$1}," \
            -e 's,.*\\ntsetup{docstatus=.*},\\ntsetup{docstatus=final},' \
            -e 's,.*\\ntsetup{spine/lauyout=.*},\\ntsetup{spine/lauyout=trim},' \
            -e 's,.*\\ntsetup{spine/width=.*},\\ntsetup{spine/width=2cm},' \
            -e 's,.*\\ntsetup{print/index=.*},\\ntsetup{print/index=true},' \
            $CONF

# build the PDF
$MAKE

# restore defaults
mv -f ${CONF}.OLD ${CONF}
