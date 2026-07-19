#!/usr/bin/env bash
#-----------------------------------------------------------------------------
# NOVAthesis — nt-variant.sh
# Version 7.11.0 (2026-06-13)
#
# Build one (or all) school variants of the template WITHOUT touching the
# working copy. Settings are injected at the command line through the
# \ntoverride mechanism (see NOVAthesisFiles/StyFiles/nt-setup.sty), so no
# temporary workspace and no config patching are needed.
#
# Usage:
#   nt-variant.sh [options] <school>     build one variant (e.g. nova/fct)
#   nt-variant.sh [options] -a [filter]  build all variants in schools.conf;
#                                        the optional filter restricts by
#                                        prefix: "nova" = all NOVA schools,
#                                        "nova/fct" = one school (and its
#                                        sub-programs). Comma-separated
#                                        filters are allowed.
#
# Options:
#   -t doctype   phd|msc|bsc   (default: highest degree in schools.conf)
#   -l lang      en|pt|...     (default: en)
#   -e engine    lua|pdf|xe    (default: lua if allowed by schools.conf)
#   -s status    working|provisional|final   (default: final)
#   -x keys      extra \ntsetup keys, e.g. 'print/index=true'
#   -o outdir    where to put the renamed PDF (default: repo root; with -a a
#                subfolder YYYY-MM-DD@hh-mm-ss is created at invocation time)
#   -j jobs      parallel jobs for -a (default: 1)
#   -n           dry run: print the latexmk commands only
#   -v           verbose: show LaTeX output
#
# Matrix mode (-a) and schools.conf semantics:
#   Each “[order: ...; processor: ...]” header starts a GROUP. The variants
#   of a group are very similar, so they are always built SEQUENTIALLY in a
#   shared aux directory: each build reuses the previous aux files (toc, bbl,
#   ...) and needs fewer LaTeX passes. The “order:” tuple sets the loop
#   nesting inside the group (last dimension varies fastest), tuned to
#   maximize that reuse. Each processor of a group gets its own sequential
#   chain and its own aux dir (pdf/lua aux files do not mix well).
#   JOBS therefore parallelizes group×engine chains, never a group's inside.
#   On failure the variant's .log is copied next to the PDFs, with the same
#   base name (univ-school-doctype-lang-engine).
#
# Environment:
#   BIBER_LOCK=1   force the biber flock shim (auto-enabled when jobs > 1)
#-----------------------------------------------------------------------------
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/.." && pwd)
CONF="$HERE/schools.conf"

# Defaults; NT_* env vars carry parent options into xargs workers (-U)
DOCTYPE="" LANG_="en" ENGINE=""
STATUS="${NT_STATUS:-final}"
EXTRA="${NT_EXTRA:-}"
OUTDIR="${NT_OUTDIR:-$ROOT}"
DRYRUN="${NT_DRYRUN:-0}"
VERBOSE="${NT_VERBOSE:-0}"
JOBS=1 ALL=0 UNITFILE=""

usage() { sed -n '3,45p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

while getopts "t:l:e:s:x:o:j:U:navh" opt; do
  case $opt in
    t) DOCTYPE=$OPTARG ;;
    l) LANG_=$OPTARG ;;
    e) ENGINE=$OPTARG ;;
    s) STATUS=$OPTARG ;;
    x) EXTRA=$OPTARG ;;
    o) OUTDIR=$(cd "$OPTARG" && pwd) ;;
    j) JOBS=$OPTARG ;;
    U) UNITFILE=$OPTARG ;;       # internal: sequential worker for one unit file
    n) DRYRUN=1 ;;
    a) ALL=1 ;;
    v) VERBOSE=1 ;;
    h) usage ;;
    *) usage 1 ;;
  esac
done
shift $((OPTIND - 1))

#--- schools.conf helpers ------------------------------------------------------
# conf_lookup <school>  ->  "doctypes|langs|processors"  (empty if not found)
conf_lookup() {
  awk -v school="$1" '
    /^\[order:/ {
      proc = $0
      sub(/.*processor:[ \t]*/, "", proc); sub(/\].*/, "", proc)
      gsub(/[ \t]/, "", proc)
      next
    }
    /^[ \t]*(#|$)/ { next }
    $1 == school {
      split($0, p, "[")
      dt = p[2]; sub(/\].*/, "", dt); gsub(/[ \t]/, "", dt)
      lg = p[3]; sub(/\].*/, "", lg); gsub(/[ \t]/, "", lg)
      print dt "|" lg "|" proc
      exit
    }' "$CONF"
}

# list_variants -> lines of "group engidx school doctype lang engine", honoring
# each group's "order:" tuple (last dimension varies fastest inside the group).
list_variants() {
  awk '
    function flush_group(   i, j, d, l, e, nd, nl, ds, ls, ndu, nlu, k) {
      if (n == 0) return
      # Unions of doctypes/langs in first-seen order (for cross-school orders)
      ndu = 0; nlu = 0
      delete DTUI; delete LGUI
      for (i = 1; i <= n; i++) {
        nd = split(D[i], ds, ",")
        for (j = 1; j <= nd; j++) if (!(ds[j] in DTUI)) DTUI[ds[j]] = ++ndu
        nl = split(L[i], ls, ",")
        for (j = 1; j <= nl; j++) if (!(ls[j] in LGUI)) LGUI[ls[j]] = ++nlu
      }
      np = split(proc, ps, ",")
      split(order, ord, ",")
      for (i = 1; i <= n; i++) {
        nd = split(D[i], ds, ",")
        for (d = 1; d <= nd; d++) {
          nl = split(L[i], ls, ",")
          for (l = 1; l <= nl; l++) {
            k["school"]  = i
            k["doctype"] = DTUI[ds[d]]
            k["lang"]    = LGUI[ls[l]]
            for (e = 1; e <= np; e++)
              printf "%02d %d %02d %02d %02d %s %s %s %s\n",
                     gid, e, k[ord[1]], k[ord[2]], k[ord[3]],
                     S[i], ds[d], ls[l], ps[e]
          }
        }
      }
      gid++; n = 0
    }
    BEGIN { gid = 1; n = 0; order = "school,doctype,lang"; proc = "lua" }
    /^\[order:/ {
      flush_group()
      order = $0
      sub(/.*order:[ \t]*/, "", order); sub(/;.*/, "", order)
      gsub(/[ \t]/, "", order)
      proc = $0
      sub(/.*processor:[ \t]*/, "", proc); sub(/\].*/, "", proc)
      gsub(/[ \t]/, "", proc)
      next
    }
    /^[ \t]*(#|$)/ { next }
    {
      split($0, p, "[")
      dt = p[2]; sub(/\].*/, "", dt); gsub(/[ \t]/, "", dt)
      lg = p[3]; sub(/\].*/, "", lg); gsub(/[ \t]/, "", lg)
      n++; S[n] = $1; D[n] = dt; L[n] = lg
    }
    END { flush_group() }
  ' "$CONF" |
  sort -n -k1,1 -k2,2 -k3,3 -k4,4 -k5,5 |
  awk '{ print $1, $2, $6, $7, $8, $9 }'
}

#--- single variant build ------------------------------------------------------
build_one() { # <school> <doctype> <lang> <engine> [shared-aux-dir]
  local school=$1 dt=$2 lg=$3 eng=$4
  local id engflag aux pretex rc=0 t0 t1
  id="$(printf '%s' "$school" | tr / -)-$dt-$lg-$eng"
  aux="${5:-$ROOT/AUXDIR/variants/$id}"
  case $eng in
    lua) engflag=-pdflua ;;
    xe)  engflag=-pdfxe ;;
    pdf) engflag=-pdf ;;
    *)   echo "✗ $id: unknown engine '$eng'" >&2; return 1 ;;
  esac
  pretex="\\def\\ntoverride{doctype=$dt,school=$school,lang=$lg,docstatus=$STATUS${EXTRA:+,$EXTRA}}"

  local cmd=(latexmk "$engflag" -interaction=batchmode -file-line-error
             -shell-escape -synctex=1 -output-directory="$aux"
             -usepretex -pretex="$pretex" template)

  if [ "$DRYRUN" = 1 ]; then
    printf '%q ' "${cmd[@]}"; echo
    return 0
  fi

  printf '▶ %s …\n' "$id" >&2               # immediate "building" feedback
  mkdir -p "$aux"
  t0=$(date +%s)
  # AUXDIR must be set per variant: latexmkrc does `$aux_dir = $ENV{AUXDIR}`,
  # and -output-directory only sets latexmk's out_dir.  Without this every
  # variant would write its .aux/.bcf/.log/minted cache into the ONE shared
  # AUXDIR exported by the Makefile — harmless when sequential, but concurrent
  # builds (JOBS>1) then trample each other and all fail.
  if [ "$VERBOSE" = 1 ]; then
    (cd "$ROOT" && AUXDIR="$aux" "${cmd[@]}") || rc=$?
  else
    (cd "$ROOT" && AUXDIR="$aux" "${cmd[@]}" > "$aux/$id.build.out" 2>&1) || rc=$?
  fi
  t1=$(date +%s)

  if [ $rc -eq 0 ]; then
    cp -f "$aux/template.pdf" "$OUTDIR/$id.pdf"
    echo "✓ $id.pdf  ($((t1 - t0))s)"
  else
    # Save whatever diagnostics exist, and report ONLY what was actually saved
    # (an early failure may leave no template.log; the captured build output
    # $id.build.out exists for non-verbose runs and holds the error).
    local saved=""
    if [ -f "$aux/template.log" ] && cp -f "$aux/template.log" "$OUTDIR/$id.log"; then
      saved="$OUTDIR/$id.log"
    fi
    if [ -f "$aux/$id.build.out" ] && cp -f "$aux/$id.build.out" "$OUTDIR/$id.build.out"; then
      saved="${saved:+$saved and }$OUTDIR/$id.build.out"
    fi
    if [ -n "$saved" ]; then
      echo "✗ $id  ($((t1 - t0))s)  — see $saved" >&2
    else
      echo "✗ $id  ($((t1 - t0))s)  — FAILED, and no log could be saved" >&2
    fi
  fi
  # In matrix mode, drop this variant's aux dir now that its PDF (or logs) are
  # in the output folder — keeps disk bounded across a large matrix.  A single
  # 'make school' does not set NT_CLEAN_AUX, so it keeps the aux for iteration.
  [ "${NT_CLEAN_AUX:-0}" = 1 ] && rm -rf "$aux"
  return $rc
}

#--- biber lock (only needed for concurrent builds) ------------------------------
enable_biber_lock() {
  export PATH="$HERE/shims:$PATH"
  command -v biber >/dev/null 2>&1 && biber --version >/dev/null 2>&1 || true  # pre-warm cache
}

#--- main -------------------------------------------------------------------------
if [ -n "$UNITFILE" ]; then
  # Worker: build the variants of one group×engine unit SEQUENTIALLY, each in
  # its OWN aux dir.  A shared aux dir made latexmk skip the rebuild for
  # variants that differ only in the \ntoverride pretex (the source files are
  # identical, and the pretex is not a tracked dependency), so every variant
  # silently reused the first one's PDF.
  unit=$(basename "$UNITFILE")
  [ "$DRYRUN" = 1 ] && echo "# unit $unit (sequential)"
  rc=0
  while read -r school dt lg eng; do
    build_one "$school" "$dt" "$lg" "$eng" || rc=1
  done < "$UNITFILE"
  exit $rc
fi

[ "${BIBER_LOCK:-0}" = 1 ] && enable_biber_lock

if [ "$ALL" = 1 ]; then
  FILTER="${1:-}"      # optional school/university prefix filter(s)
  [ "$JOBS" -gt 1 ] && enable_biber_lock
  # All matrix PDFs (and failure logs) go into a per-invocation folder
  OUTDIR="$OUTDIR/$(date +%F@%H-%M-%S)"
  [ "$DRYRUN" = 1 ] || mkdir -p "$OUTDIR"
  export NT_STATUS="$STATUS" NT_EXTRA="$EXTRA" NT_OUTDIR="$OUTDIR" \
         NT_DRYRUN="$DRYRUN" NT_VERBOSE="$VERBOSE" NT_CLEAN_AUX=1 PATH

  # Split the ordered variant list into one file per group×engine unit;
  # units run in parallel (up to JOBS), their contents strictly in order.
  UNITS=$(mktemp -d)
  list_variants |
  awk -v pat="$FILTER" '
    BEGIN { n = split(pat, ps, ",") }
    {
      if (pat == "") { print; next }
      for (i = 1; i <= n; i++)
        if ($3 == ps[i] || index($3, ps[i] "/") == 1) { print; next }
    }' |
  while read -r g e school dt lg eng; do
    printf '%s %s %s %s\n' "$school" "$dt" "$lg" "$eng" >> "$UNITS/g$g-$eng"
  done
  if ! ls "$UNITS"/* >/dev/null 2>&1; then
    echo "Error: no variant matches filter '$FILTER'." >&2
    rm -rf "$UNITS"; exit 1
  fi
  total=$(cat "$UNITS"/* | wc -l | tr -d ' ')
  printf '▶ Matrix: building %s variant(s)%s with %s job(s)\n' \
         "$total" "${FILTER:+ matching '$FILTER'}" "$JOBS" >&2
  printf '  output → %s\n' "$OUTDIR" >&2
  rc=0
  ls "$UNITS" | xargs -P "$JOBS" -I{} "$0" -U "$UNITS/{}" || rc=$?
  rm -rf "$UNITS"
  exit $rc
fi

[ $# -eq 1 ] || { echo "Error: exactly one <school> required (or -a)." >&2; usage 1; }
SCHOOL=$1

# Fill defaults from schools.conf
INFO=$(conf_lookup "$SCHOOL" || true)
if [ -n "$INFO" ]; then
  DTS=${INFO%%|*}; REST=${INFO#*|}; PRC=${REST#*|}
  [ -z "$DOCTYPE" ] && DOCTYPE=${DTS%%,*}                # first listed = highest
  if [ -z "$ENGINE" ]; then
    case ",$PRC," in *,lua,*) ENGINE=lua ;; *) ENGINE=${PRC%%,*} ;; esac
  fi
else
  echo "Warning: '$SCHOOL' not in schools.conf; using defaults." >&2
  [ -z "$DOCTYPE" ] && DOCTYPE=phd
  [ -z "$ENGINE" ]  && ENGINE=lua
fi

build_one "$SCHOOL" "$DOCTYPE" "$LANG_" "$ENGINE"
