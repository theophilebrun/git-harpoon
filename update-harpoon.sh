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

HARPOON_FILE="$HOME/.local/share/nvim/harpoon.json"

if [ ! -f "$HARPOON_FILE" ]; then
  echo "The Harpoon file does not exist at the specified location."
  exit 1
fi

MODIFIED_FILES=$(git diff $1 --name-only --diff-filter=ACM)

if [ -z "$MODIFIED_FILES" ]; then
  echo "No modified files found in the specified commits."
  exit 1
fi

PROJECT_PATH=$(pwd)

MODIFIED_FILES_WITH_POSITIONS=()

for FILE in $MODIFIED_FILES; do
  MODIFIED_FILES_WITH_POSITIONS+="{\"col\": 0, \"row\": 1, \"filename\": \"$FILE\"},"
done

MODIFIED_FILES_WITH_POSITIONS=${MODIFIED_FILES_WITH_POSITIONS%,}

jq --arg project "$PROJECT_PATH" --argjson files "[$MODIFIED_FILES_WITH_POSITIONS]" '
  .projects[$project].mark.marks = $files
' "$HARPOON_FILE" > tmp.json && mv tmp.json "$HARPOON_FILE"

echo "The Harpoon file has been updated with the modified files from the previous commits."

