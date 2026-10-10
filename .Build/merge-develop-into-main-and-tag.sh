#!/usr/bin/env bash
# Merge develop into main, tag the release with the version in nt-version.sty and push.
# Run from the repository root, AFTER bumping the version (make bump-minor|bump-patch|bump-major)
# and committing it on develop.  This script does not bump the version.
#
# Stop at the first failing command: without this, a merge conflict (or a failed
# pull/push) would let the script carry on and tag a commit that is not the release.
set -euo pipefail

# 1. Switch to main
git checkout main

# 2. Pull latest main from upstream
git pull origin main

# 3. Merge develop into main without fast-forward
git merge develop --no-ff -m "Merge develop into main"

# 3b. Sanity check: the commit-id placeholder that GitHub's export-subst fills
#     in for zip downloads (see nt-gitinfo.sty and .gitattributes) must be intact
if ! grep -qF 'Format:%h %cs$' novathesisFiles/StyFiles/nt-gitinfo.sty \
   || ! grep -q 'nt-gitinfo.sty export-subst' .gitattributes; then
  echo "ERROR: nt-gitinfo.sty placeholder or .gitattributes export-subst entry is broken; not tagging." >&2
  exit 1
fi

# 4. Extract the version from nt-version.sty and (re)tag current HEAD
VERSION=$(sed -n 's/.*\\novathesisversion}{\([^}]*\)}.*/\1/p' novathesisFiles/StyFiles/nt-version.sty)
TAG="v${VERSION}"
git tag -f "$TAG" HEAD

# 5. Push main and the force-updated tag to upstream
git push origin main
git push origin -f "$TAG"

# 6. Switch back to develop
git checkout develop
git rebase main
git push