#!/bin/bash
# ==============================================================================
# Script: check-changelog.sh
# Purpose: Verify that CHANGELOG.md has been modified in the current changes.
# Usage: ./check-changelog.sh [base_branch] [target_branch]
#
# Environment Variables:
#   SKIP_CHANGELOG_LABEL: Set to "true" if the PR has the "skip-changelog" label.
# ==============================================================================

set -e

CHANGELOG_FILE="CHANGELOG.md"
BASE_REF="${1:-origin/main}"
HEAD_REF="${2:-HEAD}"

# 1. Check for bypass label
if [[ "${SKIP_CHANGELOG_LABEL}" == "true" ]]; then
    echo "✅ CI: 'skip-changelog' label detected. Skipping check."
    exit 0
fi

echo "🔍 Checking for modifications to ${CHANGELOG_FILE} between ${BASE_REF} and ${HEAD_REF}..."

# 2. Check if file changed
if git diff --name-only "${BASE_REF}" "${HEAD_REF}" | grep -q "^${CHANGELOG_FILE}$"; then
    echo "✅ Success: ${CHANGELOG_FILE} has been modified."
    exit 0
else
    echo "❌ Error: ${CHANGELOG_FILE} was not modified in this Pull Request."
    echo ""
    echo "To fix this:"
    echo "  1. Add an entry to ${CHANGELOG_FILE} under the [Unreleased] section."
    echo "  2. If this change does not require a changelog entry (e.g. docs fix, CI tweak),"
    echo "     apply the 'skip-changelog' label to the PR."
    exit 1
fi
