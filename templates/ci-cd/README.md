---
title: "CI/CD Workflow Templates"
type: "reference"
status: "approved"
classification: "public"
category: "process"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-12-14"
version: "1.0.0"
---

# CI/CD Workflow Templates

Reusable GitHub Actions workflow templates for documentation validation.

## Quick Start (One Command)

Copy all workflows to your repo:

```bash
# From your repository root
mkdir -p .github/workflows
cp docs/standards/templates/ci-cd/*.yml .github/workflows/
```

Or copy individually:

```bash
# Full validation (recommended)
cp docs/standards/templates/ci-cd/docs-validation.yml .github/workflows/

# Individual checks
cp docs/standards/templates/ci-cd/link-checker.yml .github/workflows/
cp docs/standards/templates/ci-cd/freshness-check.yml .github/workflows/
cp docs/standards/templates/ci-cd/vale-style.yml .github/workflows/
```

## Available Templates

| Template | Purpose | Triggers On |
|----------|---------|-------------|
| [docs-validation.yml](./docs-validation.yml) | Full documentation validation | PR to docs/ |
| [documentation-check.yml](./documentation-check.yml) | **Scope-aware doc enforcement** (code changes need docs) | PR/push to main |
| [frontmatter-date-check.yml](./frontmatter-date-check.yml) | **Block PRs if last_updated not changed** | PR/push with .md changes |
| [link-checker.yml](./link-checker.yml) | Check for broken links | PR to docs/ |
| [vale-style.yml](./vale-style.yml) | Vale prose linting | PR to docs/ |
| [freshness-check.yml](./freshness-check.yml) | Detect stale documentation | Weekly schedule |
| [adr-validation.yml](./adr-validation.yml) | **ADR enforcement** (frontmatter, structure, review dates, decision linking) | PR to ADR dirs + weekly schedule |

## What Each Workflow Does

### docs-validation.yml (Recommended)

The comprehensive workflow that runs:

1. ✅ Frontmatter validation (required fields)
2. ✅ Structure validation (heading hierarchy)
3. ✅ Freshness check (stale docs warning)
4. ✅ Link checking (broken links)
5. ✅ Vale style linting (if `.vale.ini` exists)

### link-checker.yml

Standalone link checker using `markdown-link-check`. Configure via `.markdown-link-check.json`:

```json
{
  "ignorePatterns": [
    { "pattern": "^https://internal" }
  ],
  "timeout": "10s",
  "retryOn429": true
}
```

### frontmatter-date-check.yml

**Blocks PRs if markdown files are changed but `last_updated` is unchanged.** This enforces documentation hygiene by ensuring dates are updated when content changes.

| What It Checks | Behavior |
|----------------|----------|
| Modified .md file | Compares `last_updated` against base branch |
| Same date as before | ❌ **Blocks PR** |
| Different date | ✅ Passes (any date works) |
| New file | ✅ Passes |
| Deleted file | ⏭️ Skipped |
| No frontmatter | ⏭️ Skipped with warning |

**Why not require "current date"?** You might work locally for days before pushing - this only checks that you *changed* the date, not that it matches today.

### documentation-check.yml

**Scope-aware documentation enforcement.** Ensures that code changes include documentation updates within the same scope. Uses the shared `doc-enforcement.conf` and `doc-enforcement-lib.sh` from `scripts/git-hooks/`.

| Scenario | Result |
|----------|--------|
| Change `services/backend/*.py` only | FAIL — need `.md` in scope |
| Change `services/backend/*.py` + `services/backend/README.md` | PASS |
| Change test files only | PASS — tests exempt |
| Change `.github/` files only | PASS — exempt |

Requires: `scripts/git-hooks/doc-enforcement.conf` and `scripts/git-hooks/doc-enforcement-lib.sh` (see `scripts/git-hooks/README.md` for details).

### adr-validation.yml

**Full ADR enforcement.** Four jobs that validate everything the [ADR standard](../../33-ADR.md) requires:

| Job | What It Checks | When |
|-----|---------------|------|
| **Validate Frontmatter** | All required fields present, valid status values | On PR |
| **Validate Structure** | All 12 required sections present, minimum 2 references | On PR |
| **Check Review Dates** | Flags ADRs past `review_date`, warns on upcoming reviews | Weekly + manual |
| **Check Decision Linking** | `supersedes`/`superseded_by` consistency between ADRs | On PR |

Customize `ADR_DIRS` to match your ADR locations and `REVIEW_OVERDUE_DAYS` for how many days past `review_date` before it fails the check.

### freshness-check.yml

Runs weekly to detect docs that haven't been updated in 90+ days. Customize threshold in the workflow file.

### vale-style.yml

Prose linting with Vale. Requires `.vale.ini` configuration:

```ini
StylesPath = styles
MinAlertLevel = suggestion

Packages = Google, write-good, proselint, alex, Readability
Vocab = Base

[*.md]
BasedOnStyles = Vale, Google, write-good, proselint, alex, Readability
```

## Required Files

For full functionality, ensure these exist in your repo:

```
your-repo/
├── .github/
│   └── workflows/
│       ├── docs-validation.yml       # ← Copied from templates
│       └── documentation-check.yml   # ← Scope-aware enforcement
├── scripts/
│   ├── git-hooks/
│   │   ├── doc-enforcement.conf      # ← Enforcement config
│   │   ├── doc-enforcement-lib.sh    # ← Shared logic
│   │   ├── pre-commit                # ← Hook entrypoint
│   │   ├── post-commit-audit         # ← Bypass audit
│   │   ├── install.sh                # ← Hook installer
│   │   └── README.md                 # ← Documentation
│   └── docs/
│       ├── validate-frontmatter.sh
│       ├── validate-structure.sh
│       └── check-freshness.sh
├── .pre-commit-config.yaml           # ← Pre-commit configuration
├── .markdownlint-cli2.yaml           # ← Markdown linting rules
├── .vale.ini                         # Optional: for style linting
└── .markdown-link-check.json         # Optional: for link checking
```

## Customization

Each workflow includes comments explaining configurable options:

- Adjust `paths` trigger to match your docs location
- Change `continue-on-error` to `false` to block PRs on failures
- Modify schedule cron expressions for freshness checks
