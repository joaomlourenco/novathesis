#!/usr/bin/env bash
#
# matrix-prune.sh — thin out a matrix output folder down to the samples worth keeping.
#
# Runs on the CURRENT directory only, never on sibling runs, so cd into the
# folder you mean:
#
#     cd AUXDIR/matrix/2026-08-21@23-50-26
#     .Build/matrix-prune.sh -n      # show what would go, and why
#     .Build/matrix-prune.sh         # do it
#
# Rules, in priority order — the first that matches decides, so every file is
# reported with exactly one reason:
#
#   1. uminho          keep only the uminho-eeng school, drop the other uminho
#                      schools; rules 2 and 3 still apply to what is left
#   2. Portuguese      drop *-pt-*   (the English variants are the samples)
#   3. pdfLaTeX PDF    drop the pdfLaTeX-engine output (the LuaLaTeX one is
#                      the reference)
#   4. superseded msc  drop A-msc-B when A-phd-B exists
#   5. both degrees    nova-fct and uminho-eeng are exempt from rule 4
#
# A matrix id is <school>-<doctype>-<lang>-<engine>, and school names contain
# dashes (nova-fct-di-adc, nova-itqb-gray), so fields are counted from the END.
# That is why the doctype is "third from last" rather than anything matched by a
# plain -msc- substitution, which would fire inside a school name.
#
# Cover-preview SVGs (Covers/SVG/*) add one more field -- a page/crop suffix
# ("-1", "-L1", "-S") between the engine and the extension, e.g.
# "other-huberlin-phd-de-lua-L1.svg". That suffix is stripped before field
# extraction (see reason()) so the same 4-field id/rules apply there too.

set -uo pipefail
shopt -s nullglob            # an unmatched glob yields nothing instead of erroring

DRYRUN=0
UMINHO_KEEP=uminho-eeng          # the only uminho school kept
BOTH_DEGREES=('nova-fct' "$UMINHO_KEEP")   # exempt from the msc/phd rule

usage() { sed -n '3,28p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

while getopts ':nh' opt; do
  case $opt in
    n) DRYRUN=1 ;;
    h) usage ;;
    *) echo "unknown option -$OPTARG" >&2; usage 1 ;;
  esac
done
shift $((OPTIND - 1))
[ $# -eq 0 ] || { echo "error: this script takes no arguments; cd into the folder first" >&2; usage 1; }

files=(*)
[ ${#files[@]} -gt 0 ] || { echo "nothing here."; exit 0; }

# Deleting every uminho file because the keeper happens to be absent (a filtered
# run, say) would be silent data loss -- so skip rule 1 instead.
uminho_rule=1
if ! compgen -G "$UMINHO_KEEP-*" >/dev/null && compgen -G 'uminho-*' >/dev/null; then
  printf 'warning: no %s-* files here, so uminho files are left alone\n\n' "$UMINHO_KEEP" >&2
  uminho_rule=0
fi

reason() { # <file> -> prints the reason, or nothing if the file is kept
  local f=$1 parsed school doctype lang engine

  # Cover-preview SVGs (Covers/SVG/*) tack on a page/crop suffix -- "-1"
  # (page 1), "-L1" (large crop of page 1), "-S" (small thumbnail) -- right
  # before the extension, e.g. "other-huberlin-phd-de-lua-L1.svg". Parse a
  # copy of the name with that suffix stripped so school/doctype/lang/engine
  # line up the same way as for the plain matrix PDFs; without this every
  # field below would be read one position off and no rule would ever
  # match. $f itself (suffix intact) is still what gets deleted/compared
  # against below -- only the field extraction uses $parsed.
  parsed=$f
  if [[ $parsed =~ ^(.+)-(L?[0-9]+|S)(\.[^.]+)?$ ]]; then
    parsed=${BASH_REMATCH[1]}${BASH_REMATCH[3]}
  fi

  engine=${parsed%.*}; engine=${engine##*-}            # 1st field from the end
  lang=${parsed%-*}; lang=${lang##*-}                  # 2nd field from the end
  doctype=${parsed%-*}; doctype=${doctype%-*}; doctype=${doctype##*-}
  school=${parsed%-*}; school=${school%-*}; school=${school%-*}

  # other uminho schools go first; uminho-eeng falls through to the rules below
  if [ "$uminho_rule" = 1 ] && [[ $school == uminho* ]] && [ "$school" != "$UMINHO_KEEP" ]; then
    printf 'uminho: only %s is kept' "$UMINHO_KEEP"; return
  fi
  if [ "$lang" = pt ];    then printf 'Portuguese variant';  return; fi
  if [ "$engine" = pdf ]; then printf 'pdfLaTeX engine PDF'; return; fi
  if [ "$doctype" = msc ]; then
    local keep
    for keep in "${BOTH_DEGREES[@]}"; do
      [ "$school" = "$keep" ] && return            # both degrees wanted
    done
    local twin="$school-phd-${f#"$school"-msc-}"
    [ -e "$twin" ] && printf 'msc superseded by %s' "$twin"
  fi
}

removed=0 kept=0
for f in "${files[@]}"; do
  [ -f "$f" ] || continue
  why=$(reason "$f")
  if [ -n "$why" ]; then
    printf '  %s %-34s %s\n' "$([ "$DRYRUN" = 1 ] && echo 'would remove' || echo 'removed     ')" "$f" "$why"
    [ "$DRYRUN" = 1 ] || rm -- "$f"
    removed=$((removed + 1))
  else
    kept=$((kept + 1))
  fi
done

printf '\n%s %s file(s), kept %s\n' \
  "$([ "$DRYRUN" = 1 ] && echo 'would remove' || echo 'removed')" "$removed" "$kept"
[ "$DRYRUN" = 1 ] && printf 'dry run — nothing was deleted; re-run without -n to apply\n'
exit 0
