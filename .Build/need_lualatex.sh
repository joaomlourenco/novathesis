#!/bin/sh
# needlua.sh — detect schools/universities that cannot use pdfLaTeX

# Locate font style files mentioning incompatibility
# Then find corresponding .ldf files and normalize names.
TMPFILE="$(mktemp)"
GREP="${GREP:-grep -F}"

OUT=.needlualatex

# Collect all affected identifiers
NEED_LUALATEX_ALL="$(
  $GREP -rl "is not compatible with pdfLaTeX" NOVAthesisFiles/FontStyles |
  cut -d / -f 3 | cut -d . -f 1 |
  $GREP -ril -f - NOVAthesisFiles/Schools |
  $GREP .ldf |
  sed -e 's,.*/,,' -e 's,-defaults\.ldf,,' |
  tr - /
)"

# Build combined list of schools that require LuaLaTeX
for word in $NEED_LUALATEX_ALL; do
  case "$word" in
    */*) echo $word ;;
    *)   find "NOVAthesisFiles/Schools/$word" -type d -mindepth 1 -maxdepth 1 -print \
			| grep -v '/Images' \
			| cut -d / -f 3-4 ;;
  esac
done >>"$TMPFILE" 

# Deduplicate, sort, and write final list
sort -u "$TMPFILE" > ${OUT}
rm -f "$TMPFILE"

echo "✅ Saved list to ${OUT}"
