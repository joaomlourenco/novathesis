#!/bin/sh
# tag-delete.sh — delete tag locally and remotely
TAG_VERSION="${TAG_VERSION:-${VERSION}}"

echo "🗑️  Deleting tag v${TAG_VERSION}..."
if [ -z "$TAG_VERSION" ]; then
  echo "❌ Error: TAG_VERSION is required"
  echo "   Usage: make tag-delete TAG_VERSION=x.y.z"
  exit 1
fi

echo "📋 Deleting local tag..."
if git tag -d "v${TAG_VERSION}" 2>/dev/null; then
  echo "✅ Local tag deleted"
else
  echo "⚠️  Local tag not found"
fi

echo "📋 Deleting remote tag..."
if git push --delete origin "v${TAG_VERSION}" 2>/dev/null; then
  echo "✅ Remote tag deleted"
else
  echo "⚠️  Remote tag not found or no permission"
fi
