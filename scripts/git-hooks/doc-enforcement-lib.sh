#!/bin/bash
# doc-enforcement-lib.sh — Shared logic for documentation enforcement
#
# Sourced by:
#   - scripts/git-hooks/pre-commit          (local pre-commit hook)
#   - scripts/git-hooks/post-commit-audit   (bypass audit trail)
#   - .github/workflows/documentation-check.yml (CI workflow)
#
# Requires: doc-enforcement.conf sourced first (provides pattern arrays).
# Requires: bash 4.0+ (associative arrays).

# ── Scope resolution cache ───────────────────────────────────────
declare -gA _SCOPE_CACHE
declare -gA _README_CACHE

# ── Git-tracked README lookup (cached) ───────────────────────────
# Checks both tracked files AND staged files (covers new READMEs
# being committed alongside code for the first time).
_dir_has_readme() {
  local dir="$1"
  local cache_key="${dir}"

  if [[ -n "${_README_CACHE[$cache_key]+x}" ]]; then
    return "${_README_CACHE[$cache_key]}"
  fi

  # Check git index (tracked) and staged (new files being committed)
  if git ls-files --cached -- "${dir}README.md" 2>/dev/null | grep -q .; then
    _README_CACHE["$cache_key"]=0
    return 0
  fi

  _README_CACHE["$cache_key"]=1
  return 1
}

# ── resolve_scope ────────────────────────────────────────────────
# Walk up from a file's directory, checking each ancestor for a
# README.md (via git index). Returns one of:
#   "GLOBAL_DOCS" — file is under docs/ or is a global doc file
#   "EXEMPT"      — file is under .github/ or other exempt paths
#   "ROOT"        — file is at workspace root (no directory)
#   "NO_SCOPE"    — walked to root, no README found (global fallback ok)
#   "<dir>/"      — the scope directory (nearest ancestor with README.md)
#
# Results cached in _SCOPE_CACHE keyed by the file's parent directory.
resolve_scope() {
  local filepath="$1"

  # 1. Check global doc files (root-level)
  for gdf in "${GLOBAL_DOC_FILES[@]}"; do
    if [[ "$filepath" == "$gdf" ]]; then
      echo "GLOBAL_DOCS"
      return 0
    fi
  done

  # 2. Check global doc prefixes
  for prefix in "${GLOBAL_DOC_PREFIXES[@]}"; do
    if [[ "$filepath" == "${prefix}"* ]]; then
      echo "GLOBAL_DOCS"
      return 0
    fi
  done

  # 3. Root-level file (no slash = no directory component)
  if [[ "$filepath" != */* ]]; then
    echo "ROOT"
    return 0
  fi

  # 4. .github/ is always exempt
  if [[ "$filepath" == .github/* ]]; then
    echo "EXEMPT"
    return 0
  fi

  # 5. Walk up from file's directory to find nearest README.md
  local dir
  dir="$(dirname "$filepath")"

  # Check cache for this directory
  if [[ -n "${_SCOPE_CACHE[$dir]+x}" ]]; then
    echo "${_SCOPE_CACHE[$dir]}"
    return 0
  fi

  local current="$dir"
  while [[ -n "$current" && "$current" != "." ]]; do
    if _dir_has_readme "${current}/"; then
      _SCOPE_CACHE["$dir"]="${current}/"
      echo "${current}/"
      return 0
    fi
    # Move up one level
    current="$(dirname "$current")"
  done

  # 6. No README found anywhere in ancestry
  _SCOPE_CACHE["$dir"]="NO_SCOPE"
  echo "NO_SCOPE"
  return 0
}

# ── is_test_file ─────────────────────────────────────────────────
is_test_file() {
  local filepath="$1"
  for pattern in "${TEST_PATTERNS[@]}"; do
    if echo "$filepath" | grep -qE "$pattern"; then
      return 0
    fi
  done
  return 1
}

# ── is_source_file ───────────────────────────────────────────────
is_source_file() {
  local filepath="$1"

  # Exempt files are never source
  for pattern in "${EXEMPT_PATTERNS[@]}"; do
    if echo "$filepath" | grep -qE "$pattern"; then
      return 1
    fi
  done

  # Check source patterns
  for pattern in "${SOURCE_PATTERNS[@]}"; do
    if echo "$filepath" | grep -qE "$pattern"; then
      return 0
    fi
  done

  return 1
}

# ── is_doc_file ──────────────────────────────────────────────────
is_doc_file() {
  local filepath="$1"
  for pattern in "${DOC_PATTERNS[@]}"; do
    if echo "$filepath" | grep -qE "$pattern"; then
      return 0
    fi
  done
  return 1
}

# ── check_meaningful_diff ────────────────────────────────────────
# Verifies a doc file has a non-trivial change (not just whitespace).
#
# Args:
#   $1 — filepath
#   $2 — mode: "staged" (pre-commit) or "commits" (CI)
#
# For "commits" mode, caller must set DIFF_BASE_REF and DIFF_HEAD_REF.
check_meaningful_diff() {
  local filepath="$1"
  local mode="$2"
  local diff_output meaningful_lines

  if [[ "$mode" == "staged" ]]; then
    diff_output=$(git diff --cached --unified=0 -- "$filepath" 2>/dev/null || true)
  else
    diff_output=$(git diff --unified=0 "$DIFF_BASE_REF" "$DIFF_HEAD_REF" -- "$filepath" 2>/dev/null || true)
  fi

  # New file with no prior version — check staged content directly
  if [[ -z "$diff_output" ]]; then
    local content_lines
    content_lines=$(git show :"$filepath" 2>/dev/null | grep -cE '\S' || echo "0")
    if [[ "$content_lines" -ge "$MIN_DOC_DIFF_LINES" ]]; then
      return 0
    fi
    return 1
  fi

  # Count added lines (start with + but not +++) that have non-whitespace
  meaningful_lines=$(echo "$diff_output" | grep -E '^\+[^+]' | grep -cE '\S' || true)
  meaningful_lines="${meaningful_lines%%$'\n'*}"  # strip any trailing lines
  : "${meaningful_lines:=0}"

  if [[ "$meaningful_lines" -ge "$MIN_DOC_DIFF_LINES" ]]; then
    return 0
  fi

  return 1
}

# ── scope_has_tracked_readme ─────────────────────────────────────
# Check if a scope directory already has a README.md in git (tracked,
# not just staged). Used to decide whether global docs are accepted
# as fallback: global docs only count for scopes with NO existing README.
scope_has_tracked_readme() {
  local scope="$1"
  # Check only committed files (HEAD), not staged
  if git ls-tree --name-only HEAD -- "${scope}README.md" 2>/dev/null | grep -q .; then
    return 0
  fi
  # Also check index (covers first-time commits where HEAD doesn't exist yet)
  if git ls-files --cached -- "${scope}README.md" 2>/dev/null | grep -q .; then
    return 0
  fi
  return 1
}

# ── validate_scoped_docs ─────────────────────────────────────────
# Main orchestrator. Reads file list from stdin. Classifies each file
# and checks that every scope with source changes has a corresponding
# meaningful doc update.
#
# Args:
#   $1 — diff_mode: "staged" (pre-commit) or "commits" (CI)
#
# Populates global variables:
#   SCOPE_SOURCE_FILES[scope]  — newline-separated source files per scope
#   SCOPE_DOC_FILES[scope]     — newline-separated doc files per scope
#   SCOPE_TEST_FILES[scope]    — newline-separated test files per scope
#   UNSATISFIED_SCOPES         — array of scopes missing docs
#   GLOBAL_DOCS_CHANGED        — 1 if meaningful global doc was changed
#   TOTAL_SOURCE_COUNT         — total non-test source files
#   TOTAL_DOC_COUNT            — total meaningful doc files
#   TOTAL_TEST_COUNT           — total test files (exempt)
#
# Returns: 0 if all scopes satisfied, 1 if any scope is missing docs.
validate_scoped_docs() {
  local diff_mode="$1"

  declare -gA SCOPE_SOURCE_FILES=()
  declare -gA SCOPE_DOC_FILES=()
  declare -gA SCOPE_TEST_FILES=()
  declare -ga UNSATISFIED_SCOPES=()
  declare -g GLOBAL_DOCS_CHANGED=0
  declare -g TOTAL_SOURCE_COUNT=0
  declare -g TOTAL_DOC_COUNT=0
  declare -g TOTAL_TEST_COUNT=0

  local -A scopes_with_source=()
  local -A scopes_with_docs=()

  # ── Phase 1: Classify every file ──────────────────────────────
  while IFS= read -r filepath; do
    [[ -z "$filepath" ]] && continue

    local scope
    scope=$(resolve_scope "$filepath")

    # Skip exempt and root files
    if [[ "$scope" == "EXEMPT" || "$scope" == "ROOT" ]]; then
      continue
    fi

    # Track global doc changes
    if [[ "$scope" == "GLOBAL_DOCS" ]]; then
      if is_doc_file "$filepath"; then
        if check_meaningful_diff "$filepath" "$diff_mode"; then
          GLOBAL_DOCS_CHANGED=1
          TOTAL_DOC_COUNT=$((TOTAL_DOC_COUNT + 1))
        fi
      fi
      continue
    fi

    # Regular scoped file — classify as doc, test, or source
    if is_doc_file "$filepath"; then
      if check_meaningful_diff "$filepath" "$diff_mode"; then
        SCOPE_DOC_FILES["$scope"]+="${filepath}"$'\n'
        scopes_with_docs["$scope"]=1
        TOTAL_DOC_COUNT=$((TOTAL_DOC_COUNT + 1))
      fi
    elif is_source_file "$filepath"; then
      if is_test_file "$filepath"; then
        SCOPE_TEST_FILES["$scope"]+="${filepath}"$'\n'
        TOTAL_TEST_COUNT=$((TOTAL_TEST_COUNT + 1))
      else
        SCOPE_SOURCE_FILES["$scope"]+="${filepath}"$'\n'
        scopes_with_source["$scope"]=1
        TOTAL_SOURCE_COUNT=$((TOTAL_SOURCE_COUNT + 1))
      fi
    fi
    # Files matching neither source nor doc (e.g., binary without exempt
    # pattern) are silently ignored — they don't trigger enforcement.
  done

  # ── Phase 2: Check each scope ─────────────────────────────────
  for scope in "${!scopes_with_source[@]}"; do
    # Has a scoped doc update? Always satisfies.
    if [[ -n "${scopes_with_docs[$scope]+x}" ]]; then
      continue
    fi

    # No scoped doc. Check if global docs can act as fallback.
    # Global docs only count for scopes WITHOUT an existing README.
    if [[ "$GLOBAL_DOCS_CHANGED" -eq 1 ]]; then
      if ! scope_has_tracked_readme "$scope"; then
        # No README in this scope at all — global docs accepted
        continue
      fi
    fi

    # Scope is unsatisfied
    UNSATISFIED_SCOPES+=("$scope")
  done

  if [[ ${#UNSATISFIED_SCOPES[@]} -gt 0 ]]; then
    return 1
  fi
  return 0
}
