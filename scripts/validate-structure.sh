#!/bin/bash
# docs/standards/scripts/validate-structure.sh

# Purpose: Ensure README files contain "Minimum Viable Documentation" (MVD).
# Checks: Look for required headers in README.md files.

set -e

REQUIRED_HEADERS=("Overview" "Quick Start|Installation|Usage" "Owner")

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

TARGET_DIR="${1:-.}"

# Validate directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${RED}Error: Directory not found: $TARGET_DIR${NC}" >&2
    exit 1
fi

echo "🔍 Scanning README structure in '$TARGET_DIR'..."
FAILURES=0

# Find only README.md files
READMES=$(find "$TARGET_DIR" -type f -name "README.md" -not -path "*/node_modules/*")

for FILE in $READMES; do
    MISSING_HEADERS=0

    for HEADER_REGEX in "${REQUIRED_HEADERS[@]}"; do
        # Grep for header (e.g. ## Overview, # Overview)
        if ! grep -q -E "^#+.*($HEADER_REGEX)" "$FILE"; then
            echo -e "${RED}[FAIL]${NC} $FILE missing header matching: '$HEADER_REGEX'"
            MISSING_HEADERS=1
            FAILURES=$((FAILURES + 1))
        fi
    done
done

if [[ $FAILURES -gt 0 ]]; then
    echo -e "${RED}Found $FAILURES structure violations.${NC}"
    exit 1
else
    echo -e "${GREEN}All READMEs passed structure validation.${NC}"
    exit 0
fi
