#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------

NTDIR=~/LOCAL/Repos/Git/LaTeX/NOVAthesis/novathesis
SETSCHL="$NTDIR/Scripts/novathesis-set-school.py"
CLEANALL="$NTDIR/Scripts/clean-all-except.sh"

ORIGIN_USER="novathesis"
ORIGIN_REPO_BASE="https://github.com/${ORIGIN_USER}"
UPSTREAM_REPO="https://github.com/joaomlourenco/novathesis.git"

# ----------------------------------------------------------------------
# Arguments
# ----------------------------------------------------------------------

if [[ $# -lt 1 ]]; then
    # echo "Usage: $0 <course-repo-name>" >&2
    # echo "Example: $0 novathesis-msc-template" >&2
    # exit 1
	CDIR=$(basename $PWD)
	cd ..
	REPOSDIR=$(basename $PWD)
	if [ "$REPOSDIR" != "Repos" ]; then
		echo "Cant update from this folder '$CDIR', parent '$REPOSDIR."
		echo "Must be either in the folder to update or the parent 'Repos' folder."
		exit 1
	fi
else
	CDIR="$1"
fi
echo "Updating '$CDIR'…"


# ----------------------------------------------------------------------
# Check that the GitHub repo ORIGIN_USER/CDIR exists
# Full URL: ORIGIN_REPO_BASE/CDIR
# ----------------------------------------------------------------------

REMOTE_URL="${ORIGIN_REPO_BASE}/${CDIR}.git"

echo "🔍 Checking if remote repository exists: ${ORIGIN_USER}/${CDIR}"
echo "    URL: ${REMOTE_URL}"

if ! git ls-remote --exit-code "${REMOTE_URL}" &>/dev/null; then
    echo "❌ ERROR: Remote repository '${ORIGIN_USER}/${CDIR}' does not exist on GitHub." >&2
    exit 1
fi

echo "✅ Remote repository found."

# ----------------------------------------------------------------------
# Check local directory and change into it
# ----------------------------------------------------------------------

if [[ ! -d "${CDIR}" ]]; then
    echo "❌ ERROR: Local directory '${CDIR}' does not exist." >&2
    exit 1
fi

if [[ ! -d "${CDIR}/.git" ]]; then
    echo "❌ ERROR: '${CDIR}' is not a git repository." >&2
    exit 1
fi

cd "${CDIR}"

# ----------------------------------------------------------------------
# Ensure 'upstream' remote points to the NOVAthesis main repo
# ----------------------------------------------------------------------

if git remote | grep -qx "upstream"; then
    # Make sure URL is correct
    git remote set-url upstream "$UPSTREAM_REPO"
else
    git remote add upstream "$UPSTREAM_REPO"
fi

echo "🔧 Using upstream: $(git remote get-url upstream)"

# ----------------------------------------------------------------------
# Update from upstream and rebuild
# ----------------------------------------------------------------------

echo "📥 Pulling from upstream main (theirs strategy, shallow)..."
git pull --depth 1 -X theirs upstream main || true

echo "📐 Rebasing with 'theirs' strategy..."
git rebase -X theirs

echo "🏗️  make build"
.Build/build.py  -bdir . -m 1 -f nova/ensp

echo "📝 git commit"
git add .
git commit

echo "🚀 git push --force"
git push --all -f

echo "✅ Update finished successfully."
