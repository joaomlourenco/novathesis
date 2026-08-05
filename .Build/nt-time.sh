#!/bin/sh
#-----------------------------------------------------------------------------
# NOVAthesis — nt-time.sh
#
# Run a command and report the total wall-clock time it took.
#
#   nt-time.sh <command> [args...]
#
# The command's own stdout/stderr pass through untouched and its exit status is
# propagated, so this can be dropped in front of any recipe without changing
# behaviour.  The elapsed line goes to stderr, so it never pollutes a pipeline
# that is capturing the command's stdout.
#
# Wall-clock is deliberate: for a parallel `make matrix` the useful number is
# how long the user waited, not the sum of the per-variant times that
# nt-variant.sh already prints.
#
# Set NT_TIME=0 to silence the report (the command still runs).
#
# The report is yellow (same code as Scripts/nt-safe-clone.sh), but only when
# stderr is a terminal: `make matrix > log 2>&1` must not end up with escape
# codes baked into the log.  NO_COLOR=1 also disables it (informal standard).
#-----------------------------------------------------------------------------

if [ -t 2 ] && [ -z "${NO_COLOR:-}" ]; then
  YELLOW='\033[1;33m'
  NC='\033[0m'
else
  YELLOW=''
  NC=''
fi

t0=$(date +%s)
"$@"
rc=$?
t1=$(date +%s)

if [ "${NT_TIME:-1}" != 0 ]; then
  s=$((t1 - t0))
  if   [ "$s" -ge 3600 ]; then
    el=$(printf '%dh%02dm%02ds' $((s / 3600)) $(((s % 3600) / 60)) $((s % 60)))
  elif [ "$s" -ge 60 ]; then
    el=$(printf '%dm%02ds' $((s / 60)) $((s % 60)))
  else
    el=$(printf '%ds' "$s")
  fi
  if [ "$rc" -eq 0 ]; then
    printf "${YELLOW}⏱  total %s${NC}\n" "$el" >&2
  else
    # Report on failure too: a build that dies after two minutes is exactly
    # when you want to know how long it took.
    printf "${YELLOW}⏱  total %s  (failed, exit %s)${NC}\n" "$el" "$rc" >&2
  fi
fi

exit $rc
