---
title: "Documentation Validation Scripts"
type: "reference"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-01-12"
version: "1.1.0"
---

# Documentation Validation Scripts

> Automated quality enforcement for your documentation.

---

## Quick Start

```bash
# Validate frontmatter (required fields, format)
./validate-frontmatter.sh docs/

# Check document freshness (find stale docs)
./check-freshness.sh docs/

# Generate readability report
./validate-quality.sh docs/

# Scan for accidentally committed PII
./check-pii.sh docs/
```

---

## Available Scripts

| Script | Purpose | Exit Codes |
|--------|---------|------------|
| `validate-frontmatter.sh` | Check YAML metadata | 0=pass, 1=fail |
| `validate-structure.sh` | Verify required sections | 0=pass, 1=fail |
| `validate-quality.sh` | Readability metrics | 0=pass, 1=warnings |
| `validate-style.sh` | Prose linting (Vale) | 0=pass, 1=fail |
| `check-freshness.sh` | Find docs >90 days old | 0=fresh, 1=stale |
| `check-changelog.sh` | Validate CHANGELOG format | 0=pass, 1=fail |
| `check-pii.sh` | Scan for personal info | 0=clean, 1=PII found |
| `generate-ai-rules.sh` | Create AI config files | 0=success |
| `generate-quickstart.sh` | Interactive setup | 0=success |

---

## Script Details

### validate-frontmatter.sh

Ensures all markdown files have complete YAML frontmatter.

**Usage:**

```bash
./validate-frontmatter.sh [options] [directory]

Options:
  --help, -h     Show help message
  --minimal      Check only required fields (title, type, status)
  --standard     Check standard fields (default)
  --strict       Check all fields including optional ones
```

**Required Fields:**

- `title` — Document title
- `type` — Document type (standard, guide, reference, etc.)
- `status` — Approval status (draft, review, approved, stale)
- `owner` — Responsible team/person (@team-name)
- `created` — Creation date (YYYY-MM-DD)
- `last_updated` — Last modification date (YYYY-MM-DD)
- `version` — Semantic version (X.Y.Z)

**Example Output:**

```text
Checking docs/standards/...
✓ 01-PHILOSOPHY.md - All fields valid
✓ 02-KNOW_YOUR_AUDIENCE.md - All fields valid
✗ 03-DOCUMENT_TYPES.md - Missing: classification
----------------------------------------
Results: 38 passed, 2 failed, 5 warnings
```

---

### check-freshness.sh

Identifies documents that haven't been updated recently.

**Usage:**

```bash
./check-freshness.sh [directory] [days]

Arguments:
  directory    Path to scan (default: current directory)
  days         Threshold for staleness (default: 90)
```

**Example Output:**

```text
Checking document freshness (threshold: 90 days)...

⚠ STALE: docs/api/ENDPOINTS.md (last updated: 2024-08-15)
⚠ STALE: docs/deployment/AWS.md (last updated: 2024-07-22)

Found 2 stale documents out of 45 checked.
```

---

### validate-quality.sh

Generates readability metrics using Flesch-Kincaid scoring.

**Usage:**

```bash
./validate-quality.sh [directory] [output_file]

Arguments:
  directory      Path to scan (default: current directory)
  output_file    JSON report path (default: quality-report.json)
```

**Metrics Provided:**

| Metric | Target | Description |
|--------|--------|-------------|
| Flesch Reading Ease | >60 | Higher = easier to read |
| Flesch-Kincaid Grade | <12 | US grade level |
| Average Sentence Length | <25 words | Shorter = clearer |
| Complex Word % | <15% | Words with 3+ syllables |

**Example Output:**

```text
Quality Report for docs/standards/
──────────────────────────────────
Average Flesch Score: 62.4 (Good)
Average Grade Level: 9.2
Files Analyzed: 40

Top 5 Files Needing Improvement:
1. 24-SECURITY_COMPLIANCE.md (Score: 41.2)
2. 08-LANGUAGE_SPECIFIC.md (Score: 48.7)
3. 07-GOVERNANCE.md (Score: 52.1)
```

---

### check-pii.sh

Scans for accidentally committed personal information.

**Usage:**

```bash
./check-pii.sh [directory]
```

**Patterns Detected:**

- Social Security Numbers (US format)
- Credit card numbers
- Email addresses (configurable)
- Phone numbers
- API keys and tokens
- IP addresses

**Example Output:**

```text
Scanning for PII in docs/...

⚠ POTENTIAL PII: docs/examples/config.md:45
  Pattern: Email address
  Content: "contact john.doe@company.com for..."

Found 1 potential PII match. Please review.
```

---

### validate-structure.sh

Verifies README files contain required sections.

**Usage:**

```bash
./validate-structure.sh [directory]
```

**Required Sections:**

- Overview or Introduction
- Installation or Setup
- Usage or Quick Start
- API or Configuration (if applicable)

---

### check-changelog.sh

Validates CHANGELOG.md follows Keep a Changelog format.

**Usage:**

```bash
./check-changelog.sh [base_ref] [head_ref]

Arguments:
  base_ref    Base branch (default: origin/main)
  head_ref    Head branch (default: HEAD)
```

**Environment Variables:**

- `SKIP_CHANGELOG_LABEL` — PR label to skip check

---

### generate-ai-rules.sh

Creates AI assistant configuration files.

**Usage:**

```bash
./generate-ai-rules.sh [output_directory]
```

**Files Created:**

- `.cursorrules` — Cursor AI configuration
- `AGENTS.md` — Agent behavior guidelines
- `.github/copilot-instructions.md` — GitHub Copilot config

---

### generate-quickstart.sh

Interactive setup wizard for new projects.

**Usage:**

```bash
./generate-quickstart.sh
```

**Prompts For:**

- Project context (Solo/OSS/Team/Enterprise)
- Installation directory
- Feature selection

---

## Platform Compatibility

| Script | Linux | macOS | Windows (Git Bash) | Alpine |
|--------|-------|-------|-------------------|--------|
| `validate-frontmatter.sh` | ✅ | ✅ | ✅ | ✅ |
| `check-freshness.sh` | ✅ | ✅ | ✅ | ✅ |
| `validate-quality.sh` | ✅ | ✅ | ✅ | ✅ |
| `validate-style.sh` | ✅ | ✅ | ✅ | ✅ |
| `check-pii.sh` | ✅ | ✅* | ✅ | ✅ |
| `check-changelog.sh` | ✅ | ✅ | ✅ | ✅ |

*macOS: Install `ggrep` for full regex support: `brew install grep`

### Dependencies

| Dependency | Required By | Installation |
|------------|-------------|--------------|
| Bash 4.0+ | All scripts | Pre-installed |
| `awk` | `validate-quality.sh` | Pre-installed |
| `grep` | All scripts | Pre-installed |
| `ggrep` | `check-pii.sh` (macOS) | `brew install grep` |
| Vale | `validate-style.sh` | `brew install vale` |

---

## CI/CD Integration

### GitHub Actions

```yaml
name: Documentation Quality

on:
  pull_request:
    paths:
      - 'docs/**'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Validate Frontmatter
        run: ./docs/standards/scripts/validate-frontmatter.sh docs/

      - name: Check Freshness
        run: ./docs/standards/scripts/check-freshness.sh docs/

      - name: Quality Report
        run: ./docs/standards/scripts/validate-quality.sh docs/ report.json

      - name: Upload Report
        uses: actions/upload-artifact@v4
        with:
          name: quality-report
          path: report.json
```

### Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Validate changed markdown files
CHANGED_MD=$(git diff --cached --name-only --diff-filter=ACM | grep '\.md$')

if [[ -n "$CHANGED_MD" ]]; then
    ./docs/standards/scripts/validate-frontmatter.sh --minimal .
    if [[ $? -ne 0 ]]; then
        echo "Frontmatter validation failed. Please fix before committing."
        exit 1
    fi
fi
```

---

## Troubleshooting

### "date: invalid option -- 'd'"

**Cause:** macOS uses BSD date, not GNU date.

**Solution:** Scripts auto-detect platform. If issues persist:

```bash
brew install coreutils
# Use gdate instead of date
```

### "grep: invalid option -- 'P'"

**Cause:** macOS grep doesn't support Perl regex.

**Solution:**

```bash
brew install grep
# Scripts will auto-detect ggrep
```

### "Permission denied"

**Solution:**

```bash
chmod +x docs/standards/scripts/*.sh
```

### Script reports "0 files checked"

**Cause:** Directory path incorrect or no .md files found.

**Solution:** Verify the path exists and contains markdown files:

```bash
ls docs/standards/*.md
```

---

## Contributing

Contributions welcome! Common improvements:

- macOS compatibility fixes
- Better error messages
- New validation rules
- Performance improvements

See [CONTRIBUTING.md](../../../CONTRIBUTING.md) for guidelines.
