#!/bin/sh
# tag-show.sh — show full details for a specific tag
TAG_VERSION="${TAG_VERSION:-${VERSION}}"

if [ -z "$TAG_VERSION" ]; then
  echo "❌ Error: TAG_VERSION is required"
  echo "   Usage: make tag-show TAG_VERSION=x.y.z"
  exit 1
fi

if git show "v${TAG_VERSION}" >/dev/null 2>&1; then
  echo "📋 Details for tag v${TAG_VERSION}:"
  git show "v${TAG_VERSION}" --quiet --pretty=fuller
else
  echo "❌ Tag v${TAG_VERSION} not found"
fi
