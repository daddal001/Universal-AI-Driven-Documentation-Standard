#!/bin/bash
# docs/standards/scripts/validate-style.sh

# Purpose: Wrapper for 'vale' linter.
# Note: Requires 'vale' to be installed.

set -e

# ANSI colors
RED='\033[0;31m'
NC='\033[0m'

if ! command -v vale &> /dev/null; then
    echo -e "${RED}Error: 'vale' is not installed.${NC}"
    echo "Please install it: https://vale.sh/docs/vale-cli/installation/"
    echo "Or run 'brew install vale' / 'choco install vale'"
    exit 1
fi

echo "🔍 Running Vale linter..."
# Assume .vale.ini is in root or we pass config path
vale docs/ --minAlertLevel=error
