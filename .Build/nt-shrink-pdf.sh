#!/bin/sh
#-----------------------------------------------------------------------------
# novathesis — nt-shrink-pdf.sh
#
# Shrink a PDF's raster images (via Ghostscript) until the file fits a
# target size, in megabytes. Invoked by the Makefile when SIZE=x is set,
# right after the PDF is copied out of AUXDIR -- but it works standalone:
#
#   nt-shrink-pdf.sh <target-MB> <pdf-file>
#
# Binary-searches the downsample resolution (DPI) Ghostscript applies to
# color/gray/mono images, re-running 'gs -sDEVICE=pdfwrite' at each
# candidate DPI until it converges on the highest DPI (best quality) that
# still fits under the target. Vector graphics, fonts and text are left
# alone -- only raster images are resampled, so a PDF with little or no
# raster content may never reach a small target; that case is reported
# instead of looping forever.
#
# Overwrites <pdf-file> in place; the pre-shrink build is kept alongside it
# as <pdf-file>.orig so it is never lost.
#-----------------------------------------------------------------------------

set -eu

TARGET_MB=${1:?"usage: nt-shrink-pdf.sh <target-MB> <pdf-file>"}
PDF=${2:?"usage: nt-shrink-pdf.sh <target-MB> <pdf-file>"}

command -v gs >/dev/null 2>&1 || {
  echo "nt-shrink-pdf.sh: ERROR: Ghostscript (gs) not found -- SIZE=$TARGET_MB was ignored." >&2
  echo "  Install it (e.g. 'brew install ghostscript' / 'apt install ghostscript') and rebuild." >&2
  exit 1
}
[ -f "$PDF" ] || { echo "nt-shrink-pdf.sh: ERROR: '$PDF' not found." >&2; exit 1; }

case "$TARGET_MB" in
  ''|*[!0-9.]*)
    echo "nt-shrink-pdf.sh: ERROR: SIZE must be a positive number of megabytes, got '$TARGET_MB'." >&2
    exit 1 ;;
esac

mb() { awk -v b="$1" 'BEGIN { printf "%.1f", b / 1024 / 1024 }'; }

TARGET_BYTES=$(awk -v mb="$TARGET_MB" 'BEGIN { printf "%.0f", mb * 1024 * 1024 }')
ORIG_SIZE=$(wc -c < "$PDF" | tr -d ' ')

if [ "$ORIG_SIZE" -le "$TARGET_BYTES" ]; then
  echo "nt-shrink-pdf.sh: $PDF is already $(mb "$ORIG_SIZE")M (target ${TARGET_MB}M) -- left untouched."
  exit 0
fi

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

# Prints the resulting size in bytes on stdout, or -1 if Ghostscript failed
# (the caller checks for that; 'exit' in here would only kill the
# command-substitution subshell, not the whole script).
shrink_at() {
  dpi="$1"
  if gs -q -dBATCH -dNOPAUSE -dSAFER -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 \
        -dDetectDuplicateImages=true -dCompressFonts=true -dSubsetFonts=true \
        -dDownsampleColorImages=true -dColorImageResolution="$dpi" -dAutoFilterColorImages=false -dColorImageFilter=/DCTEncode \
        -dDownsampleGrayImages=true  -dGrayImageResolution="$dpi"  -dAutoFilterGrayImages=false  -dGrayImageFilter=/DCTEncode \
        -dDownsampleMonoImages=true  -dMonoImageResolution="$dpi" \
        -sOutputFile="$WORKDIR/try.pdf" "$PDF" >"$WORKDIR/gs.log" 2>&1
  then
    wc -c < "$WORKDIR/try.pdf" | tr -d ' '
  else
    echo -1
  fi
}

DPI_LOW=36
DPI_HIGH=600

echo "nt-shrink-pdf.sh: $PDF is $(mb "$ORIG_SIZE")M, target is ${TARGET_MB}M -- searching for a resolution that fits..."

LOW_SIZE=$(shrink_at "$DPI_LOW")
[ "$LOW_SIZE" != -1 ] || { echo "nt-shrink-pdf.sh: ERROR: Ghostscript failed -- see $WORKDIR/gs.log" >&2; cat "$WORKDIR/gs.log" >&2; exit 1; }

if [ "$LOW_SIZE" -gt "$TARGET_BYTES" ]; then
  echo "nt-shrink-pdf.sh: WARNING: even at ${DPI_LOW}dpi the PDF is $(mb "$LOW_SIZE")M -- target ${TARGET_MB}M is not reachable by downsampling images alone." >&2
  echo "  (large vector figures, embedded fonts, or many raster images all count against the budget)" >&2
  cp "$WORKDIR/try.pdf" "$PDF.orig.$$"
  mv "$PDF" "$PDF.orig"
  mv "$PDF.orig.$$" "$PDF"
  echo "nt-shrink-pdf.sh: wrote the smallest achievable PDF ($(mb "$LOW_SIZE")M) to $PDF; original build kept as $PDF.orig"
  exit 0
fi

BEST_DPI=$DPI_LOW
cp "$WORKDIR/try.pdf" "$WORKDIR/best.pdf"

while [ $((DPI_HIGH - DPI_LOW)) -gt 4 ]; do
  DPI_MID=$(( (DPI_LOW + DPI_HIGH) / 2 ))
  echo "  trying ${DPI_MID}dpi..."
  MID_SIZE=$(shrink_at "$DPI_MID")
  [ "$MID_SIZE" != -1 ] || { echo "nt-shrink-pdf.sh: ERROR: Ghostscript failed at ${DPI_MID}dpi -- see $WORKDIR/gs.log" >&2; cat "$WORKDIR/gs.log" >&2; exit 1; }
  if [ "$MID_SIZE" -le "$TARGET_BYTES" ]; then
    DPI_LOW=$DPI_MID
    BEST_DPI=$DPI_MID
    cp "$WORKDIR/try.pdf" "$WORKDIR/best.pdf"
  else
    DPI_HIGH=$DPI_MID
  fi
done

mv "$PDF" "$PDF.orig"
mv "$WORKDIR/best.pdf" "$PDF"
FINAL_SIZE=$(wc -c < "$PDF" | tr -d ' ')
echo "nt-shrink-pdf.sh: shrank $PDF from $(mb "$ORIG_SIZE")M to $(mb "$FINAL_SIZE")M (images downsampled to ${BEST_DPI}dpi)."
echo "  original build kept as $PDF.orig -- re-run 'make' to restore full quality."
echo "  Note: downsampling can affect PDF/A compliance -- re-validate with VeraPDF if docstatus=final."
