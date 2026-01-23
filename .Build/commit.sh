#!/bin/sh
# commit.sh — performs safe commit with pre-checks

RED="$(printf '\033[31m')"
YELLOW="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"
RESET="$(printf '\033[0m')"


VERSION_FILE="NOVAthesisFiles/StyFiles/nt-version.sty"

# Extract Version and Date
# Note: used "$VERSION_FILE" (double quotes) so the shell expands the variable.
# used $4 in awk to grab the content inside the second set of curly braces.
VERSION=$(awk -F'[{}]' '/\\novathesisversion/ {print $4; exit}' "$VERSION_FILE")
DATE=$(awk -F'[{}]' '/\\novathesisdate/    {print $4; exit}' "$VERSION_FILE")

# Check if either variable is empty
if [[ -z "$VERSION" || -z "$DATE" ]]; then
    echo "Error: Could not parse VERSION or DATE from $VERSION_FILE" >&2
    exit 1
fi

printf "%s-------------------------------------------------------------%s\n" "$RED" "$RESET"
echo "📝 Starting commit process..."
printf "%sVERSION=%s%s%s - DATE=%s%s%s\n" "$CYAN" "$YELLOW" "$VERSION" "$CYAN" "$YELLOW" "$DATE" "$RESET"
printf "%s-------------------------------------------------------------%s\n" "$RED" "$RESET"

# 1) Pre-commit checks
# -------------------------------------------------------------

# Git repo check
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "❌ Error: Not in a git repository"
  exit 1
fi

# Branch check
CURRENT_BRANCH="$(git branch --show-current 2>/dev/null || echo detached)"
if [ "$CURRENT_BRANCH" = "detached" ] || [ -z "$CURRENT_BRANCH" ]; then
  echo "❌ Error: Not on a branch (detached HEAD state)"
  exit 1
fi

# Modified files check
if [ -z "$(git status --porcelain)" ]; then
  echo "❌ Error: No modified files to commit"
  exit 1
fi

# Show what will be committed
echo "📋 Files to be committed:"
git status --short

# Stage files
if [ "$COMMIT_INCLUDE_UNTRACKED" = "yes" ]; then
  git add .
else
  git add -u
fi

# 2) Create the commit
# -------------------------------------------------------------
COMMIT_MESSAGE="${COMMIT_MESSAGE:-v($VERSION - $DATE)}"
if git commit -m "$COMMIT_MESSAGE"; then
  COMMIT_HASH="$(git rev-parse --short HEAD)"
  echo "📦 Commit Summary:"
  echo "   Hash:    $COMMIT_HASH"
  echo "   Branch:  $CURRENT_BRANCH"
  echo "   Message: $COMMIT_MESSAGE"
else
  echo "❌ Failed to create commit"
  echo "   This might be because there were no changes to commit after staging"
  exit 1
fi

printf "🎉 Commit process completed successfully!\n\n"
