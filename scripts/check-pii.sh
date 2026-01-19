#!/bin/bash
# docs/standards/scripts/check-pii.sh
#
# Purpose: Scan text files for potential PII patterns (Email, SSN, Credit Card, API Keys)
# Usage: ./check-pii.sh [file_or_directory]
#
# Note: This script uses grep -P (Perl regex) for advanced patterns.
# On macOS, install GNU grep: brew install grep (then use ggrep)

set -uo pipefail

# Default to current directory if no argument provided
TARGET="${1:-.}"

# Validate target exists
if [[ ! -e "$TARGET" ]]; then
    echo -e "${RED}Error: Path not found: $TARGET${NC}" >&2
    exit 1
fi

# Exit code tracking
EXIT_CODE=0

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Detect if grep -P is available (not on macOS default grep)
GREP_CMD="grep"
if ! grep -P "" /dev/null 2>/dev/null; then
    # Try ggrep (GNU grep on macOS via Homebrew)
    if command -v ggrep &>/dev/null; then
        GREP_CMD="ggrep"
        echo -e "${YELLOW}Using GNU grep (ggrep) for Perl regex support${NC}"
    else
        echo -e "${YELLOW}⚠️  Warning: grep -P (Perl regex) not available.${NC}"
        echo -e "${YELLOW}   On macOS, install GNU grep: brew install grep${NC}"
        echo -e "${YELLOW}   Falling back to basic patterns (less accurate)${NC}"
        echo ""

        # Fallback to basic extended regex patterns
        USE_BASIC=true
    fi
fi

echo "🔍 Scanning for PII in: $TARGET"

if [[ "${USE_BASIC:-false}" == "true" ]]; then
    # Basic patterns (POSIX extended regex) - less accurate but works everywhere

    echo "   Checking for email patterns..."
    $GREP_CMD -rEn --include='*.md' --include='*.txt' --include='*.json' --include='*.yaml' --include='*.yml' \
        "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" "$TARGET" 2>/dev/null | \
        grep -v "example\.com" | grep -v "example\.org" | grep -v "test\.com" && {
        echo -e "${RED}❌ Potential Real Email Detected${NC}"
        EXIT_CODE=1
    }

    echo "   Checking for exposed secrets/keys..."
    $GREP_CMD -rEn --include='*.md' --include='*.txt' --include='*.json' --include='*.yaml' --include='*.yml' \
        "(sk-[a-zA-Z0-9]{32,}|ghp_[a-zA-Z0-9]{30,}|xox[baprs]-)" "$TARGET" 2>/dev/null && {
        echo -e "${RED}❌ Potential Secret/Key Detected${NC}"
        EXIT_CODE=1
    }

    echo "   Checking for SSN patterns..."
    $GREP_CMD -rEn --include='*.md' --include='*.txt' --include='*.json' --include='*.yaml' --include='*.yml' \
        "[0-9]{3}-[0-9]{2}-[0-9]{4}" "$TARGET" 2>/dev/null && {
        echo -e "${RED}❌ Potential SSN Detected${NC}"
        EXIT_CODE=1
    }

    echo "   Checking for Credit Card patterns..."
    $GREP_CMD -rEn --include='*.md' --include='*.txt' --include='*.json' --include='*.yaml' --include='*.yml' \
        "[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}" "$TARGET" 2>/dev/null && {
        echo -e "${RED}❌ Potential Credit Card Number Detected${NC}"
        EXIT_CODE=1
    }
else
    # Full Perl regex patterns (more accurate)

    # 1. Email Addresses (excluding example.com/org/net)
    echo "   Checking for real email addresses..."
    $GREP_CMD -rPn --include='*.md' --include='*.txt' --include='*.json' --include='*.yaml' --include='*.yml' \
        "[a-zA-Z0-9._%+-]+@(?!(example\.(com|org|net)|test\.com))[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" "$TARGET" 2>/dev/null && {
        echo -e "${RED}❌ Potential Real Email Detected${NC}"
        EXIT_CODE=1
    }

    # 2. Key/Token Patterns (Basic heuristics)
    echo "   Checking for exposed secrets/keys..."
    $GREP_CMD -rPn --include='*.md' --include='*.txt' --include='*.json' --include='*.yaml' --include='*.yml' \
        "(sk-[a-zA-Z0-9]{32,}|ghp_[a-zA-Z0-9]{30,}|xox[baprs]-|api_key[:=]\s*[a-zA-Z0-9]{20,})" "$TARGET" 2>/dev/null && {
        echo -e "${RED}❌ Potential Secret/Key Detected${NC}"
        EXIT_CODE=1
    }

    # 3. US Social Security Numbers (Simple xxx-xx-xxxx check)
    echo "   Checking for SSN patterns..."
    $GREP_CMD -rPn --include='*.md' --include='*.txt' --include='*.json' --include='*.yaml' --include='*.yml' \
        "\b\d{3}-\d{2}-\d{4}\b" "$TARGET" 2>/dev/null && {
        echo -e "${RED}❌ Potential SSN Detected${NC}"
        EXIT_CODE=1
    }

    # 4. Credit Card Numbers (16 digits check, simple)
    echo "   Checking for Credit Card patterns..."
    $GREP_CMD -rPn --include='*.md' --include='*.txt' --include='*.json' --include='*.yaml' --include='*.yml' \
        "\b\d{4}[ -]?\d{4}[ -]?\d{4}[ -]?\d{4}\b" "$TARGET" 2>/dev/null && {
        echo -e "${RED}❌ Potential Credit Card Number Detected${NC}"
        EXIT_CODE=1
    }
fi

if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ No obvious PII patterns detected.${NC}"
else
    echo -e "${RED}⚠️  PII Check Failed. Please review the matches above.${NC}"
fi

exit $EXIT_CODE
