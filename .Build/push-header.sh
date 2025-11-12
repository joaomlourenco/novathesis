#!/bin/sh
# push-header.sh — header for the push workflow

RED="$(printf '\033[31m')"
YELLOW="$(printf '\033[33m')"
CYAN="$(printf '\033[36m')"
RESET="$(printf '\033[0m')"

printf "%s-------------------------------------------------------------%s\n" "$RED" "$RESET"
echo "🏷️ Starting pushing process..."
printf "%sVERSION=%s%s%s - DATE=%s%s%s.\n" "$CYAN" "$YELLOW" "$VERSION" "$CYAN" "$YELLOW" "$DATE" "$RESET"
printf "%s-------------------------------------------------------------%s\n" "$RED" "$RESET"
