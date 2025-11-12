#!/bin/sh
# tag.sh — create version tag on develop and main

RED="$(printf '\033[31m')"
YELLOW="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"
RESET="$(printf '\033[0m')"

TAG_VERSION="${TAG_VERSION:-${VERSION}}"
TAG_DATE="${TAG_DATE:-${DATE}}"
TAG_MESSAGE="${TAG_MESSAGE:-Version ${TAG_VERSION} - ${TAG_DATE}.}"

printf "%s-------------------------------------------------------------%s\n" "$RED" "$RESET"
echo "🏷️  Starting tagging process..."
printf "%sVERSION=%s%s%s - DATE=%s%s%s.\n" "$CYAN" "$YELLOW" "$VERSION" "$CYAN" "$YELLOW" "$DATE" "$RESET"
printf "%s-------------------------------------------------------------%s\n" "$RED" "$RESET"

# Ensure in git repo
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "❌ Error: Not in a git repository"
  exit 1
fi

# Ensure on develop branch
CURRENT_BRANCH="$(git branch --show-current)"
if [ "$CURRENT_BRANCH" != "develop" ]; then
  echo "❌ Error: You must be on the 'develop' branch (currently on '$CURRENT_BRANCH')"
  exit 1
fi

# Ensure no uncommitted changes
if [ -n "$(git status --porcelain 2>/dev/null | grep -Fv '??')" ]; then
  echo "❌ Error: You have uncommitted changes. Please commit or stash them first."
  git status --short
  exit 1
fi

# Ensure version present
if [ -z "$TAG_VERSION" ]; then
  echo "❌ Error: TAG_VERSION is required"
  echo "   Usage: make tag TAG_VERSION=x.y.z"
  exit 1
fi

echo "✅ Version: $TAG_VERSION"
echo "✅ Date: $TAG_DATE"
echo "✅ Message: $TAG_MESSAGE"

# Warn if tag exists
if git rev-parse "v$TAG_VERSION" >/dev/null 2>&1; then
  echo "⚠️  Warning: Tag 'v$TAG_VERSION' already exists. Will overwrite."
fi

# Check main branch exists
if ! git show-ref --verify --quiet refs/heads/main; then
  echo "❌ Error: main branch does not exist"
  exit 1
fi

# Fetch updates (best effort)
git fetch origin 2>/dev/null || echo "⚠️  Could not fetch from origin"

# Tag develop
if git tag -a "v$TAG_VERSION" -f -m "$TAG_MESSAGE" 2>/dev/null; then
  echo "✅ Tag created on develop branch"
fi

# Checkout main and tag
if ! git checkout main 2>/dev/null; then
  echo "❌ Failed to checkout main branch"
  exit 1
fi

if git tag -a "v$TAG_VERSION" -f -m "$TAG_MESSAGE" 2>/dev/null; then
  echo "✅ Tag created on main branch"
fi

# Return to develop
if ! git checkout develop 2>/dev/null; then
  echo "❌ Failed to return to develop branch"
  exit 1
fi

# Show info
echo "📋 Tag information:"
echo "   Tag: v$TAG_VERSION"
echo "   Message: $TAG_MESSAGE"
echo "   Commit: $(git rev-parse --short "v$TAG_VERSION")"

echo "🎉 Tagging process completed successfully!"
