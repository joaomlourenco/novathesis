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
#   1. uminho          keep only uminho-eeng-msc-en-lua.pdf, drop the rest
#   2. Portuguese      drop *-pt-*   (the English variants are the samples)
#   3. pdfLaTeX PDF    drop *pdf.pdf (the LuaLaTeX output is the reference)
#   4. superseded msc  drop A-msc-B when A-phd-B exists
#   5. nova-fct        exempt from rule 4: both degrees are kept
#
# A matrix id is <school>-<doctype>-<lang>-<engine>, and school names contain
# dashes (nova-fct-di-adc, nova-itqb-gray), so fields are counted from the END.
# That is why the doctype is "third from last" rather than anything matched by a
# plain -msc- substitution, which would fire inside a school name.

set -uo pipefail
shopt -s nullglob            # an unmatched glob yields nothing instead of erroring

DRYRUN=0
KEEPER=uminho-eeng-msc-en-lua.pdf

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
if [ ! -e "$KEEPER" ] && compgen -G 'uminho-*' >/dev/null; then
  printf 'warning: %s is not here, so uminho files are left alone\n\n' "$KEEPER" >&2
  uminho_rule=0
fi

reason() { # <file> -> prints the reason, or nothing if the file is kept
  local f=$1 school doctype lang
  lang=${f%-*}; lang=${lang##*-}                       # 2nd field from the end
  doctype=${f%-*}; doctype=${doctype%-*}; doctype=${doctype##*-}
  school=${f%-*}; school=${school%-*}; school=${school%-*}

  if [ "$uminho_rule" = 1 ] && [[ $school == uminho* ]]; then
    [ "$f" = "$KEEPER" ] || printf 'uminho: only %s is kept' "$KEEPER"
    return
  fi
  if [ "$lang" = pt ];       then printf 'Portuguese variant';   return; fi
  if [[ $f == *pdf.pdf ]];   then printf 'pdfLaTeX engine PDF';  return; fi
  if [ "$doctype" = msc ] && [ "$school" != nova-fct ]; then
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
