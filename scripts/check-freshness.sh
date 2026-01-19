#!/bin/bash
# docs/standards/scripts/check-freshness.sh

# Purpose: Flag stale documentation based on frontmatter or git history.
# Logic:
#   1. Check `last_updated` or `freshness.reviewed` in frontmatter.
#   2. If present, compare to today. Warn if > 90 days.
#   3. If missing, check last git commit date. Warn if > 90 days.

set -e

THRESHOLD_DAYS=90
CURRENT_DATE=$(date +%s)
SECONDS_PER_DAY=86400
THRESHOLD_SECONDS=$((THRESHOLD_DAYS * SECONDS_PER_DAY))

# ANSI colors
YELLOW='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TARGET_DIR="${1:-.}"

# Validate directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${RED}Error: Directory not found: $TARGET_DIR${NC}" >&2
    exit 1
fi

echo "🔍 Checking documentation freshness in '$TARGET_DIR' (Threshold: $THRESHOLD_DAYS days)..."
STALE_COUNT=0

# Find MD files
FILES=$(find "$TARGET_DIR" -type f -name "*.md" -not -path "*/node_modules/*")

for FILE in $FILES; do
    # Try to extract date from frontmatter (last_updated OR freshness: { reviewed: ... })
    # Simplification: grep for YYYY-MM-DD pattern in first 20 lines
    DOC_DATE_STR=$(head -n 20 "$FILE" | grep -E "last_updated:|reviewed:" | head -n 1 | grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2}")

    if [[ -n "$DOC_DATE_STR" ]]; then
        CHECK_TYPE="Frontmatter"
        # Cross-platform date parsing (macOS uses -j, Linux uses -d)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            DOC_TIMESTAMP=$(date -j -f "%Y-%m-%d" "$DOC_DATE_STR" +%s 2>/dev/null || echo "0")
        else
            DOC_TIMESTAMP=$(date -d "$DOC_DATE_STR" +%s 2>/dev/null || echo "0")
        fi
    else
        CHECK_TYPE="Git"
        # Get last commit date for file
        DOC_TIMESTAMP=$(git log -1 --format=%ct "$FILE")
    fi

    if [[ "$DOC_TIMESTAMP" == "0" || -z "$DOC_TIMESTAMP" ]]; then
        # Skip if no date found (e.g. new file not in git yet)
        continue
    fi

    AGE_SECONDS=$((CURRENT_DATE - DOC_TIMESTAMP))

    if [[ $AGE_SECONDS -gt $THRESHOLD_SECONDS ]]; then
        DAYS_OLD=$((AGE_SECONDS / SECONDS_PER_DAY))
        OWNER=$(head -n 10 "$FILE" | grep "owner:" | cut -d ':' -f 2 | xargs)
        echo -e "${YELLOW}[STALE]${NC} $FILE is $DAYS_OLD days old ($CHECK_TYPE). Owner: ${OWNER:-Unknown}"
        STALE_COUNT=$((STALE_COUNT + 1))
    fi
done

if [[ $STALE_COUNT -gt 0 ]]; then
    echo -e "${YELLOW}Found $STALE_COUNT stale documents.${NC}"
    # Exit 1 to signal stale docs found (useful for CI/CD)
    exit 1
else
    echo -e "${GREEN}All documents are fresh.${NC}"
    exit 0
fi
