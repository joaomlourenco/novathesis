#!/bin/sh
# commit-push-force.sh — performs a force push of the current branch (use with caution)

RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

echo "${RED}💥 FORCE PUSH MODE - Use with caution!${RESET}"

# Ask for confirmation
# printf "${YELLOW}Are you sure you want to force push? (y/N): ${RESET}"
# read confirm
# if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
#     echo "❌ Force push cancelled by user"
#     exit 1
# fi

# Detect current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
if [ -z "$CURRENT_BRANCH" ]; then
    echo "❌ Error: Not on a valid branch"
    exit 1
fi

PUSH_REMOTE="${PUSH_REMOTE:-origin}"

echo "🔄 Force pushing ${CURRENT_BRANCH} to ${PUSH_REMOTE}..."
if git push "$PUSH_REMOTE" "$CURRENT_BRANCH" --force; then
    echo "✅ Force push completed"
else
    echo "❌ Force push failed"
    exit 1
fi
