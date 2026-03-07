# Git Hooks

This directory contains hook helpers used by the `pre-commit` framework to enforce documentation standards.

## Installation

Install hooks after cloning the repository:

```bash
bash scripts/git-hooks/install.sh
```

This installs:

- `pre-commit` hook (runs on `git commit`, scanning all tracked files)
- `post-commit` hook (audits `--no-verify` bypasses)

If `pre-commit` is not installed, the installer creates a native `post-commit` fallback for bypass auditing.

You can also install manually:

```bash
pre-commit install
```

Then run `bash scripts/git-hooks/install.sh` once to apply the repository `--all-files` pre-commit patch.

## Active Hooks — Pre-Commit Stage

These hooks run on every `git commit`:

### `docs-enforcement`

- **Entry:** `scripts/git-hooks/pre-commit`
- **Trigger:** every commit
- **Behavior:** scope-aware documentation enforcement. Rejects commits that include source code changes without a documentation update **within the same scope**.

#### How scope resolution works

The hook walks up from each changed file's directory looking for a `README.md`:

```text
Given: services/backend-ai/routes/chat.py

Step 1: Is there a README.md in services/backend-ai/routes/ ?  → NO
Step 2: Is there a README.md in services/backend-ai/ ?          → YES → SCOPE
Result: Must update a .md file within services/backend-ai/
```

- **Auto-discovering:** Adding a new folder with `README.md` automatically creates an enforced scope. No config changes needed.
- **Global docs fallback:** If walk-up reaches workspace root with no `README.md` found, `docs/` and `CHANGELOG.md` are accepted as fallback.
- **Strict scopes:** If a scope has a `README.md` anywhere in the ancestry, global docs are NOT accepted — you must update a `.md` within that scope.

#### Source file types

TypeScript, JavaScript, Python, Go, Rust, Java, C/C++, Terraform (`.tf`), HCL (`.hcl`), and Shell (`.sh`).

#### Test file exemption

Test files (`*_test.py`, `*.test.tsx`, `*.spec.ts`, files under `tests/`) are source code but exempt from the documentation requirement.

#### Meaningful diff requirement

Documentation changes must have at least 1 non-whitespace line added. Whitespace-only `.md` edits do not satisfy the requirement.

#### Enforcement mode

Set `DOC_ENFORCEMENT_MODE` in `doc-enforcement.conf`:

- `"enforce"` — blocks the commit (exit 1)
- `"warn"` — prints a yellow warning but allows the commit (exit 0)

#### Enforcement rules

| Scenario | Result |
|----------|--------|
| Change `services/backend/*.py` only | FAIL — need `.md` in `services/backend/` |
| Change `services/backend/*.py` + `services/backend/README.md` | PASS |
| Change `services/backend/*.py` + `apps/frontend/README.md` | FAIL — wrong scope |
| Change `services/backend/*.py` + `docs/ARCHITECTURE.md` | FAIL — scope has README, must update within scope |
| Change `services/backend/tests/test_chat.py` only | PASS — tests exempt |
| Change 3 services, only 1 has README update | FAIL — 2 scopes unsatisfied |
| New dir `tools/cli/main.py` (no README anywhere up) + `docs/NEW_TOOL.md` | PASS — no scope README, global fallback |
| Whitespace-only change to a README | FAIL — not meaningful |
| Change `.github/workflows/ci.yml` only | PASS — `.github/` exempt |

#### Bypass audit trail

Every commit is audited by `scripts/git-hooks/post-commit-audit`. If a commit would have failed enforcement (i.e., was made with `--no-verify`), a structured log line is appended to `.git/doc-enforcement-audit.log`:

```text
[2026-03-03T14:22:00Z] BYPASS: commit=a1b2c3d author="Dev Name <dev@co.com>" unsatisfied_scopes="services/backend/"
```

The audit log lives in `.git/` (not committed, not pushed). Team leads can review it periodically.

#### Shared code

| File | Purpose |
|------|---------|
| `doc-enforcement.conf` | Shared patterns, thresholds, mode setting |
| `doc-enforcement-lib.sh` | Shared logic (scope resolution, validation) |
| `pre-commit` | Local hook entrypoint |
| `post-commit-audit` | Bypass audit trail |

The CI workflow (`templates/ci-cd/documentation-check.yml`) sources the same `conf` + `lib` files to ensure zero drift between local and CI enforcement.

### `markdownlint-cli2`

- **Repo:** `https://github.com/DavidAnson/markdownlint-cli2`
- **Trigger:** every commit (Markdown files)
- **Behavior:** lints and auto-fixes Markdown formatting. Config: `.markdownlint-cli2.yaml`.

### General hygiene hooks

From `pre-commit-hooks`:

- `trailing-whitespace` — fixes trailing whitespace
- `end-of-file-fixer` — ensures files end with a newline
- `check-yaml` — validates YAML syntax
- `check-merge-conflict` — detects leftover merge conflict markers

## Requirements

- **Bash 4.0+** (associative arrays). macOS ships Bash 3.2 — install via `brew install bash`.
- **pre-commit** — `pip install pre-commit` or `uv tool install pre-commit`

## Hook Scope

Commit-time checks run with `--all-files`, so local commits validate the full repository instead of only staged paths. This behavior is applied by `scripts/git-hooks/install.sh`.

## Emergency Bypass

```bash
git commit --no-verify -m "hotfix: ..."
```

Bypassed commits are logged to `.git/doc-enforcement-audit.log` and should be followed by a compliance commit immediately.

## Troubleshooting

### Hooks are not running

```bash
ls -la .git/hooks/pre-commit
ls -la .git/hooks/post-commit
bash scripts/git-hooks/install.sh
```

### Run hooks manually

```bash
# Run all pre-commit hooks
pre-commit run --all-files

# Run individual hooks
pre-commit run docs-enforcement --all-files
pre-commit run markdownlint-cli2 --all-files
```

### Bash version too old (macOS)

The docs-enforcement hook requires Bash 4.0+ for associative arrays. macOS ships Bash 3.2.

```bash
brew install bash
# Ensure /opt/homebrew/bin/bash is used (add to PATH or update shell)
```
