#!/bin/bash
# docs/standards/scripts/validate-frontmatter.sh
#
# Purpose: Validate YAML frontmatter in Markdown files.
# Usage:
#   ./validate-frontmatter.sh [directory] [--minimal|--strict]
#
# Modes:
#   --minimal  OSS mode: Only require title, type, status, owner, last_updated
#   --strict   Enterprise mode: Require all fields including classification, category
#   (default)  Standard mode: Balanced requirements
#
# Examples:
#   ./validate-frontmatter.sh docs/                    # Standard mode
#   ./validate-frontmatter.sh docs/ --minimal          # OSS-friendly
#   ./validate-frontmatter.sh docs/ --strict           # Enterprise

set -e

# Parse arguments
TARGET_DIR="."
MODE="standard"

for arg in "$@"; do
    case $arg in
        --minimal)
            MODE="minimal"
            ;;
        --strict)
            MODE="strict"
            ;;
        -h|--help)
            echo "Usage: $0 [directory] [--minimal|--strict]"
            echo ""
            echo "Modes:"
            echo "  --minimal  OSS mode: title, type, status, owner, last_updated"
            echo "  --strict   Enterprise: All fields including classification, category"
            echo "  (default)  Standard: title, type, status, owner, last_updated"
            exit 0
            ;;
        *)
            if [[ -d "$arg" ]]; then
                TARGET_DIR="$arg"
            fi
            ;;
    esac
done

# Configure field requirements based on mode
case $MODE in
    minimal)
        REQUIRED_FIELDS=("title" "type" "status" "owner" "last_updated")
        RECOMMENDED_FIELDS=("created" "version")
        ;;
    strict)
        REQUIRED_FIELDS=("title" "type" "status" "owner" "classification" "category" "last_updated" "created" "version")
        RECOMMENDED_FIELDS=()
        ;;
    *)
        # Standard mode - balanced
        REQUIRED_FIELDS=("title" "type" "status" "owner" "last_updated")
        RECOMMENDED_FIELDS=("created" "version" "classification" "category")
        ;;
esac

# Valid values
VALID_TYPES=("readme" "architecture" "adr" "api" "changelog" "runbook" "security-playbook" "disaster-recovery" "oncall" "slo" "infrastructure" "cicd" "compliance" "getting-started" "guide" "tutorial" "reference" "landing" "standard" "glossary" "postmortem" "migration" "troubleshooting" "faq" "how-to" "example" "policy" "template" "conceptual" "error-reference" "service-readme" "legal")
VALID_STATUSES=("draft" "review" "approved" "stale" "deprecated" "proposed" "accepted" "superseded")
VALID_CATEGORIES=("security" "infrastructure" "api" "data" "operations" "development" "architecture" "process" "documentation" "governance")
VALID_CLASSIFICATIONS=("public" "internal" "confidential" "restricted")

# ANSI colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${RED}Error: Directory not found: $TARGET_DIR${NC}" >&2
    echo "Usage: $0 [directory] [--minimal|--strict]" >&2
    exit 1
fi

echo -e "${BLUE}🔍 Validating frontmatter in '$TARGET_DIR' (mode: $MODE)${NC}"
echo ""
FAILURES=0
WARNINGS=0
CHECKED=0

# Find all MD files, excluding node_modules and templates
FILES=$(find "$TARGET_DIR" -type f -name "*.md" -not -path "*/node_modules/*" 2>/dev/null || true)

for FILE in $FILES; do
    # 1. Check if frontmatter exists (starts with ---)
    # Strip \r for Windows CRLF compatibility
    FIRST_LINE=$(head -n 1 "$FILE" 2>/dev/null | tr -d '\r' || true)
    if [[ "$FIRST_LINE" != "---" ]]; then
        # Skip files without frontmatter (not an error for OSS)
        continue
    fi

    CHECKED=$((CHECKED + 1))

    # 2. Extract frontmatter block (between first --- and second ---)
    # Strip \r for Windows CRLF compatibility
    END_LINE=$(tr -d '\r' < "$FILE" | awk 'NR>1 && /^---$/ {print NR; exit}')
    if [[ -z "$END_LINE" ]]; then
        echo -e "${RED}[FAIL]${NC} $FILE has unclosed frontmatter block"
        FAILURES=$((FAILURES + 1))
        continue
    fi
    FRONTMATTER=$(sed -n "2,$((END_LINE - 1))p" "$FILE")

    # 3. Check Required Fields
    for FIELD in "${REQUIRED_FIELDS[@]}"; do
        if ! echo "$FRONTMATTER" | grep -q "^$FIELD:"; then
            echo -e "${RED}[FAIL]${NC} $FILE missing required field: '$FIELD'"
            FAILURES=$((FAILURES + 1))
        fi
    done

    # 4. Check Recommended Fields (warnings only)
    for FIELD in "${RECOMMENDED_FIELDS[@]}"; do
        if ! echo "$FRONTMATTER" | grep -q "^$FIELD:"; then
            echo -e "${YELLOW}[WARN]${NC} $FILE missing recommended field: '$FIELD'"
            WARNINGS=$((WARNINGS + 1))
        fi
    done

    # 5. Check 'type' validity
    TYPE=$(echo "$FRONTMATTER" | grep "^type:" | cut -d ':' -f 2 | xargs | tr -d '"' | tr -d "'" 2>/dev/null || true)
    if [[ -n "$TYPE" ]]; then
        IS_VALID_TYPE=0
        for T in "${VALID_TYPES[@]}"; do
            if [[ "$T" == "$TYPE" ]]; then IS_VALID_TYPE=1; break; fi
        done
        if [[ $IS_VALID_TYPE -eq 0 ]]; then
            echo -e "${RED}[FAIL]${NC} $FILE has invalid type: '$TYPE'"
            echo -e "        Valid types: ${VALID_TYPES[*]}"
            FAILURES=$((FAILURES + 1))
        fi
    fi

    # 6. Check 'status' validity
    STATUS=$(echo "$FRONTMATTER" | grep "^status:" | cut -d ':' -f 2 | xargs | tr -d '"' | tr -d "'" 2>/dev/null || true)
    if [[ -n "$STATUS" ]]; then
        IS_VALID_STATUS=0
        for S in "${VALID_STATUSES[@]}"; do
            if [[ "$S" == "$STATUS" ]]; then IS_VALID_STATUS=1; break; fi
        done
        if [[ $IS_VALID_STATUS -eq 0 ]]; then
            echo -e "${RED}[FAIL]${NC} $FILE has invalid status: '$STATUS'"
            FAILURES=$((FAILURES + 1))
        fi
    fi

    # 7. Check 'category' validity (if present)
    CATEGORY=$(echo "$FRONTMATTER" | grep "^category:" | cut -d ':' -f 2 | xargs | tr -d '"' | tr -d "'" 2>/dev/null || true)
    if [[ -n "$CATEGORY" ]]; then
        IS_VALID_CATEGORY=0
        for C in "${VALID_CATEGORIES[@]}"; do
            if [[ "$C" == "$CATEGORY" ]]; then IS_VALID_CATEGORY=1; break; fi
        done
        if [[ $IS_VALID_CATEGORY -eq 0 ]]; then
            echo -e "${RED}[FAIL]${NC} $FILE has invalid category: '$CATEGORY'"
            FAILURES=$((FAILURES + 1))
        fi
    fi

    # 8. Check 'classification' validity (if present)
    CLASSIFICATION=$(echo "$FRONTMATTER" | grep "^classification:" | cut -d ':' -f 2 | xargs | tr -d '"' | tr -d "'" 2>/dev/null || true)
    if [[ -n "$CLASSIFICATION" ]]; then
        IS_VALID_CLASS=0
        for CL in "${VALID_CLASSIFICATIONS[@]}"; do
            if [[ "$CL" == "$CLASSIFICATION" ]]; then IS_VALID_CLASS=1; break; fi
        done
        if [[ $IS_VALID_CLASS -eq 0 ]]; then
            echo -e "${RED}[FAIL]${NC} $FILE has invalid classification: '$CLASSIFICATION'"
            FAILURES=$((FAILURES + 1))
        fi
    fi

done

echo ""
echo -e "${BLUE}Checked $CHECKED files with frontmatter${NC}"

if [[ $FAILURES -gt 0 ]]; then
    echo -e "${RED}❌ Found $FAILURES frontmatter violations.${NC}"
    [[ $WARNINGS -gt 0 ]] && echo -e "${YELLOW}⚠️  Found $WARNINGS warnings.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All files passed frontmatter validation.${NC}"
    [[ $WARNINGS -gt 0 ]] && echo -e "${YELLOW}⚠️  Found $WARNINGS warnings (non-blocking).${NC}"
    exit 0
fi
