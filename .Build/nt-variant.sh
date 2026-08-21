#!/usr/bin/env bash
#-----------------------------------------------------------------------------
# novathesis — nt-variant.sh
# Version 8.2.0 (2026-08-21)
#
# Build one (or all) school variants of the template WITHOUT touching the
# working copy. Settings are injected at the command line through the
# \ntoverride mechanism (see novathesisFiles/StyFiles/nt-setup.sty), so no
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
#                (this is what Makefile.dev's 'make school'/'make matrix' NT=
#                variable is forwarded through as; renamed at the Make level
#                for consistency with the main Makefile's NT=, but left as -x
#                here since it only appends to \ntoverride, not replace it)
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
#   NT_WARM=0      one fresh (cold) aux dir per variant; default 1 shares a warm
#                  aux dir within each sequential unit for faster rebuilds
#   NT_COST_DEFAULT=N  assumed seconds for a variant with no recorded time
#                  (default 60).  Matrix units are dispatched longest-first
#                  (LPT) using measured times cached in .Build/.matrix-costs.tsv;
#                  delete that file to reset to group-id order.  Each variant
#                  keeps its last NT_COST_HISTORY runs (default 5, comma-list
#                  in the tsv's 2nd column) and is scheduled on their average,
#                  smoothing one-off outliers (e.g. a cold run, or a build that
#                  happened to land on an efficiency core under heavy JOBS
#                  contention) instead of just chasing the latest sample.
#   NT_COST_HISTORY=N  how many recent timings to average per variant
#                  (default 5); does not retroactively shrink/grow history
#                  already on disk, only how many a future merge keeps.
#-----------------------------------------------------------------------------
set -euo pipefail

# Colors for status lines (▶ start, ✓ success, ✗ failure). Disabled when
# stdout isn't a terminal (e.g. piped to a file/CI log) or NO_COLOR is set.
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_GREEN=$'\033[32m'; C_RED=$'\033[31m'; C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m';  C_BOLD=$'\033[1m'; C_RESET=$'\033[0m'
else
  C_GREEN="" C_RED="" C_YELLOW="" C_BLUE="" C_BOLD="" C_RESET=""
fi

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
#--- per-variant outcome recording (matrix summary) ------------------------------
# One file per variant id, like NT_TIMINGS_DIR: parallel workers never contend.
# A no-op outside matrix mode, where NT_RESULTS_DIR is unset.
nt_record() { # <ok|fail> <id> <secs> <reason>
  [ -n "${NT_RESULTS_DIR:-}" ] || return 0
  printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" > "$NT_RESULTS_DIR/$2"
}

# First real TeX error from the logs, condensed to one line, so the summary can
# say WHY a variant failed instead of only that it did.  Two wrinkles: with
# -file-line-error the message starts "file:line: ", and TeX hard-wraps the log
# at 79 columns -- so the next line is glued on before trimming, otherwise
# "Missing file 'x.clo'" arrives as "Missing fi".  The file:line form is
# preferred over "! ..." because the latter also matches math in error context.
nt_reason() { # <log> <build.out>
  local f msg
  for f in "$@"; do
    [ -f "$f" ] || continue
    msg=$(awk '/^[^ ]*:[0-9]+: /{ l=$0; if ((getline n) > 0) l = l n; print l; exit }' "$f")
    [ -n "$msg" ] || msg=$(awk '/^! /{ l=substr($0,3)
                                       if ((getline n) > 0 && n !~ /^(l\.|$)/) l = l n
                                       print l; exit }' "$f")
    if [ -n "$msg" ]; then
      printf '%s' "$msg" |
        sed -e 's|^[^ ]*:[0-9]*: ||' -e 's/  */ /g' -e 's/ *$//' | cut -c1-70
      return 0
    fi
  done
  printf 'build error'
}

build_one() { # <school> <doctype> <lang> <engine> [shared-aux-dir]
  local school=$1 dt=$2 lg=$3 eng=$4
  local id engflag aux ovr ovrrel owns_aux jobname rc=0 t0 t1
  id="$(printf '%s' "$school" | tr / -)-$dt-$lg-$eng"
  if [ -n "${5:-}" ]; then
    aux="$5"; owns_aux=0            # shared (warm) aux dir, owned by the caller
  else
    aux="$ROOT/AUXDIR/variants/$id"; owns_aux=1
  fi
  # jobname = the aux-dir basename: stable within a (warm) unit but DISTINCT
  # across parallel units and cold variants.  This keeps every \jobname-keyed
  # file that a tool drops in the shared cwd -- minted's _minted-<jobname>,
  # ifplatform's <jobname>.w18, etc. -- from colliding between concurrent builds.
  jobname="$(basename "$aux")"
  case $eng in
    lua) engflag=-pdflua ;;
    xe)  engflag=-pdfxe ;;
    pdf) engflag=-pdf ;;
    *)   printf '%s✗ %s: unknown engine '\''%s'\''%s\n' "$C_RED" "$id" "$eng" "$C_RESET" >&2; return 1 ;;
  esac

  # Inject \ntoverride through a FILE that latexmk tracks as a dependency,
  # instead of -pretex (which latexmk ignores for up-to-date checks).  This is
  # what makes a shared (warm) aux dir safe: rewriting the file forces a rebuild
  # for the next school, so latexmk can no longer silently reuse the previous
  # variant's PDF, while it still skips the unchanged steps (biber, bib2gls) and
  # converges in fewer passes.  The \input path is relative to the compile cwd
  # ($ROOT); AUXDIR has no spaces, so it stays safe for texfot too.
  ovr="$aux/nt-override.tex"
  ovrrel="${aux#"$ROOT"/}/nt-override.tex"

  # -jobname is REQUIRED: the pretex starts with \input{override}, and without a
  # fixed jobname the engine would name every output after that first file
  # (override.pdf) instead of <jobname>.pdf.  Using the per-unit jobname also
  # de-collides tool caches in the shared cwd (see the jobname note above).
  local cmd=(latexmk "$engflag" -interaction=batchmode -file-line-error
             -shell-escape -synctex=1 -output-directory="$aux" -jobname="$jobname"
             -usepretex -pretex="\\input{$ovrrel}" template)

  if [ "$DRYRUN" = 1 ]; then
    printf '# %s -> \\input{%s}\n' "$id" "$ovrrel"
    printf '%q ' "${cmd[@]}"; echo
    return 0
  fi

  printf '%s▶ %s …%s\n' "$C_BLUE" "$id" "$C_RESET" >&2   # immediate "building" feedback
  mkdir -p "$aux"
  # (Re)write the tracked override.  FASTWRITES=0 also re-enables morewrites.
  {
    printf '\\def\\ntoverride{doctype=%s,school=%s,lang=%s,docstatus=%s%s}\n' \
           "$dt" "$school" "$lg" "$STATUS" "${EXTRA:+,$EXTRA}"
    if [ "${FASTWRITES:-1}" != 1 ]; then printf '\\def\\ntmorewrites{}\n'; fi
  } > "$ovr"
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

  # A clean exit status is not enough: with bib2gls a wrong 'selection' drops
  # glossary entries silently — the build succeeds and the page count does not
  # even change.  Assert the glossaries really are intact before calling it a
  # pass.  A missing checker or interpreter must not fail the variant.
  if [ $rc -eq 0 ] && [ -x "$ROOT/.Build/check-glossaries.py" ]; then
    if ! glscheck=$("$ROOT/.Build/check-glossaries.py" "$aux" "$jobname" "$ROOT" 2>&1); then
      rc=1
      printf '%s\n' "$glscheck" > "$aux/$id.glossary.out"
    fi
  fi

  if [ $rc -eq 0 ]; then
    cp -f "$aux/$jobname.pdf" "$OUTDIR/$id.pdf"
    printf '%s✓ %s.pdf%s  %s(%ss)%s\n' "$C_GREEN" "$id" "$C_RESET" "$C_YELLOW" "$((t1 - t0))" "$C_RESET"
    # Record this variant's build time for cost-based (LPT) unit scheduling.
    # One file per variant id => no contention across parallel workers.
    if [ -n "${NT_TIMINGS_DIR:-}" ]; then
      printf '%s\t%s\n' "$id" "$((t1 - t0))" > "$NT_TIMINGS_DIR/$id"
    fi
    nt_record ok "$id" "$((t1 - t0))" ''
  else
    if [ -f "$aux/$id.glossary.out" ]; then
      cp -f "$aux/$id.glossary.out" "$OUTDIR/$id.glossary.out" 2>/dev/null || true
      printf '%s✗ %s  (%ss)  — glossary check failed:%s\n' "$C_RED" "$id" "$((t1 - t0))" "$C_RESET" >&2
      sed 's/^/    /' "$aux/$id.glossary.out" >&2
      nt_record fail "$id" "$((t1 - t0))" 'glossary check'
      return 1
    fi
    # Save whatever diagnostics exist, and report ONLY what was actually saved
    # (an early failure may leave no <jobname>.log; the captured build output
    # $id.build.out exists for non-verbose runs and holds the error).
    local saved=""
    if [ -f "$aux/$jobname.log" ] && cp -f "$aux/$jobname.log" "$OUTDIR/$id.log"; then
      saved="$OUTDIR/$id.log"
    fi
    if [ -f "$aux/$id.build.out" ] && cp -f "$aux/$id.build.out" "$OUTDIR/$id.build.out"; then
      saved="${saved:+$saved and }$OUTDIR/$id.build.out"
    fi
    if [ -n "$saved" ]; then
      printf '%s✗ %s  (%ss)  — see %s%s\n' "$C_RED" "$id" "$((t1 - t0))" "$saved" "$C_RESET" >&2
    else
      printf '%s✗ %s  (%ss)  — FAILED, and no log could be saved%s\n' "$C_RED" "$id" "$((t1 - t0))" "$C_RESET" >&2
    fi
    nt_record fail "$id" "$((t1 - t0))" "$(nt_reason "$OUTDIR/$id.log" "$OUTDIR/$id.build.out")"
  fi
  # In matrix mode, drop this variant's aux dir now that its PDF (or logs) are
  # in the output folder — keeps disk bounded across a large matrix.  A single
  # 'make school' does not set NT_CLEAN_AUX, so it keeps the aux for iteration.
  # Only drop the aux dir if this call OWNS it (a per-variant cold dir).  A
  # shared warm dir is cleaned once by the worker after the whole unit finishes.
  if [ "$owns_aux" = 1 ] && [ "${NT_CLEAN_AUX:-0}" = 1 ]; then rm -rf "$aux"; fi
  return $rc
}

#--- biber lock (only needed for concurrent builds) ------------------------------
enable_biber_lock() {
  export PATH="$HERE/shims:$PATH"
  command -v biber >/dev/null 2>&1 && biber --version >/dev/null 2>&1 || true  # pre-warm cache
}

#--- main -------------------------------------------------------------------------
if [ -n "$UNITFILE" ]; then
  # Worker: build the variants of one group×engine unit SEQUENTIALLY.  With
  # NT_WARM=1 (default) they share ONE aux dir, so each variant reuses the
  # previous one's warm .aux/.bbl/.glstex and converges in fewer passes.  This
  # is safe because \ntoverride is now a tracked file (see build_one): changing
  # school rewrites it, forcing latexmk to rebuild — it can no longer reuse the
  # previous variant's PDF.  NT_WARM=0 restores a fresh cold aux dir per variant.
  unit=$(basename "$UNITFILE")
  unitaux=""
  if [ "${NT_WARM:-1}" = 1 ]; then unitaux="$ROOT/AUXDIR/units/$unit"; fi
  [ "$DRYRUN" = 1 ] && echo "# unit $unit (sequential${unitaux:+, warm aux})"
  rc=0
  while read -r school dt lg eng; do
    build_one "$school" "$dt" "$lg" "$eng" ${unitaux:+"$unitaux"} || rc=1
  done < "$UNITFILE"
  if [ -n "$unitaux" ] && [ "${NT_CLEAN_AUX:-0}" = 1 ]; then rm -rf "$unitaux"; fi
  exit $rc
fi

[ "${BIBER_LOCK:-0}" = 1 ] && enable_biber_lock

if [ "$ALL" = 1 ]; then
  FILTER="${1:-}"      # optional school/university prefix filter(s)
  [ "$JOBS" -gt 1 ] && enable_biber_lock
  # All matrix PDFs (and failure logs) go into a per-invocation folder
  OUTDIR="$OUTDIR/$(date +%F@%H-%M-%S)"
  [ "$DRYRUN" = 1 ] || mkdir -p "$OUTDIR"
  # Cost-based (LPT) scheduling: a per-run dir collects each variant's build
  # time (one file per id -> no locking), merged afterwards into a persistent
  # cost DB used to order units longest-first.
  NT_TIMINGS_DIR=$(mktemp -d)
  NT_RESULTS_DIR=$(mktemp -d)
  COSTDB="$HERE/.matrix-costs.tsv"; touch "$COSTDB"
  export NT_STATUS="$STATUS" NT_EXTRA="$EXTRA" NT_OUTDIR="$OUTDIR" \
         NT_DRYRUN="$DRYRUN" NT_VERBOSE="$VERBOSE" NT_CLEAN_AUX=1 \
         NT_WARM="${NT_WARM:-1}" NT_TIMINGS_DIR="$NT_TIMINGS_DIR" \
         NT_RESULTS_DIR="$NT_RESULTS_DIR" PATH

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
  printf '%s%s▶ Matrix: building %s variant(s)%s with %s job(s)%s\n' \
         "$C_BOLD" "$C_BLUE" "$total" "${FILTER:+ matching '$FILTER'}" "$JOBS" "$C_RESET" >&2
  printf '  output → %s\n' "$OUTDIR" >&2
  # Dispatch longest-first (LPT): a unit's cost is the sum of its variants'
  # average of their last NT_COST_HISTORY recorded build times (a comma-list
  # in the db's 2nd column; NT_COST_DEFAULT for variants with no history at
  # all).  An empty DB or ties fall back to group-id order.  This only
  # changes WHEN units start, never the result.  FILENAME==db (not FNR==NR)
  # is robust to an empty cost DB.
  order_units() {
    awk -v def="${NT_COST_DEFAULT:-60}" -v db="$COSTDB" '
      FILENAME == db {
        k = split($2, hist, ",")
        sum = 0
        for (i = 1; i <= k; i++) sum += hist[i]
        cost[$1] = sum / k
        next
      }
      { id = $1; gsub(/\//, "-", id); id = id "-" $2 "-" $3 "-" $4
        tot[FILENAME] += (id in cost) ? cost[id] : def }
      END { for (p in tot) { n = split(p, x, "/"); printf "%d\t%s\n", tot[p], x[n] } }
    ' "$COSTDB" "$UNITS"/* | sort -k1,1rn -k2,2 | cut -f2
  }
  rc=0
  order_units | xargs -P "$JOBS" -I{} "$0" -U "$UNITS/{}" || rc=$?
  # Merge this run's times into the persistent cost DB: append each variant's
  # fresh timing to its existing comma-list history and keep only the last
  # NT_COST_HISTORY entries (oldest dropped first), rather than replacing the
  # single stored value outright. A variant with no prior history starts a
  # fresh one-entry list.
  if [ "$DRYRUN" != 1 ] && ls "$NT_TIMINGS_DIR"/* >/dev/null 2>&1; then
    cat "$NT_TIMINGS_DIR"/* > "$NT_TIMINGS_DIR/.new"
    awk -F'\t' -v keep="${NT_COST_HISTORY:-5}" '
      FNR==NR { new[$1] = $2; next }
      {
        id = $1
        if (id in new) {
          full = $2 "," new[id]
          cnt = split(full, arr, ",")
          start = (cnt > keep) ? cnt - keep + 1 : 1
          out = arr[start]
          for (i = start + 1; i <= cnt; i++) out = out "," arr[i]
          print id "\t" out
          seen[id] = 1
        } else {
          print
        }
      }
      END { for (id in new) if (!(id in seen)) print id "\t" new[id] }
    ' "$NT_TIMINGS_DIR/.new" "$COSTDB" > "$COSTDB.tmp" && mv "$COSTDB.tmp" "$COSTDB"
  fi
  # ---- summary ---------------------------------------------------------------
  # Counted from the recorded outcomes, not from the files in OUTDIR: a variant
  # that dies before writing any log would otherwise vanish from the tally.
  # One awk pass, no grep pipeline -- 'grep -c' with no match exits 1, and under
  # 'set -o pipefail' that would abort the whole run right at the finish line.
  built=0; failed=0
  if ls "$NT_RESULTS_DIR"/* >/dev/null 2>&1; then
    counts=$(awk -F'\t' '$1=="ok"{o++} $1=="fail"{f++} END{printf "%d %d", o+0, f+0}' \
             "$NT_RESULTS_DIR"/*)
    built=${counts% *}; failed=${counts#* }
  fi
  missing=$((total - built - failed))
  printf '\n%s%s▶ Matrix summary: %s/%s built' "$C_BOLD" "$C_BLUE" "$built" "$total" >&2
  if [ "$failed" -gt 0 ]; then printf ', %s failed' "$failed" >&2; fi
  if [ "$missing" -gt 0 ]; then printf ', %s never ran' "$missing" >&2; fi
  printf '%s\n' "$C_RESET" >&2
  if [ "$failed" -gt 0 ]; then
    printf '%s  failed:%s\n' "$C_RED" "$C_RESET" >&2
    awk -F'\t' '$1=="fail" {printf "    %-38s %s\n", $2, $4}' "$NT_RESULTS_DIR"/* |
      sort >&2
    printf '  logs → %s\n' "$OUTDIR" >&2
  fi
  rm -rf "$UNITS" "$NT_TIMINGS_DIR" "$NT_RESULTS_DIR"
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
