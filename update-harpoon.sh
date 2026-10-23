#!/bin/bash

if [ ! -d .git ]; then
  echo "This directory is not a Git repository."
  exit 1
fi

if [ -z "$1" ]; then
  echo "Error: no parameter specified for git diff."
  echo "Usage: $(basename $0) <commit/range>"
  exit 1
fi

PROJECT_PATH=$(pwd)
HARPOON_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/harpoon"
# Harpoon 2 stores one file per project, named after the sha256 of the cwd
HARPOON_FILE="$HARPOON_DIR/$(printf %s "$PROJECT_PATH" | sha256sum | cut -d' ' -f1).json"

MODIFIED_FILES=$(git diff "$1" --name-only --diff-filter=ACM) || exit 1

if [ -z "$MODIFIED_FILES" ]; then
  echo "No modified files found in the specified commits."
  exit 1
fi

[ -f "$HARPOON_FILE" ] || echo '{}' > "$HARPOON_FILE"

# Each list item is itself a JSON-encoded string in Harpoon 2
jq --arg project "$PROJECT_PATH" --arg files "$MODIFIED_FILES" '
  .[$project].__harpoon_files = [
    $files | split("\n")[] | {value: ., context: {col: 0, row: 1}} | tojson
  ]
' "$HARPOON_FILE" > "$HARPOON_FILE.tmp" && mv "$HARPOON_FILE.tmp" "$HARPOON_FILE"

echo "The Harpoon file has been updated with the modified files from the previous commits."
