# Documentation Templates

This directory contains reusable templates and configuration files for documentation projects.

## Available Templates

### Document Templates

See tier-specific directories:

| Tier | Templates | Best For |
|------|-----------|----------|
| [tier-1-system](./tier-1-system/) | SERVICE_README, ARCHITECTURE, ADR, API, CHANGELOG, CONFIGURATION, ERROR_CATALOG | All projects |
| [tier-2-operational](./tier-2-operational/) | RUNBOOK, ONCALL_GUIDE, SLO | Production services |
| [tier-3-developer](./tier-3-developer/) | GETTING_STARTED, HOW_TO | Developer onboarding |
| [tier-4-process](./tier-4-process/) | MIGRATION, POSTMORTEM | Process documentation |
| [tier-5-troubleshooting](./tier-5-troubleshooting/) | FAQ, TROUBLESHOOTING | Support docs |
| [tier-enterprise](./tier-enterprise/) | COMPLIANCE_MATRIX, AUDIT_TRAIL, DATA_CLASSIFICATION, VENDOR_DOCUMENTATION | Compliance needs |
| [tier-oss](./tier-oss/) | CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, LICENSE, CHANGELOG | Open source projects |

### CI/CD Workflows

See [ci-cd/](./ci-cd/) directory for GitHub Actions workflow templates:

| Workflow | Purpose |
|----------|---------|
| `docs-validation.yml` | Comprehensive documentation validation (frontmatter, structure, links, linting) |
| `documentation-check.yml` | Scope-aware doc enforcement — blocks PRs that change code without updating docs |
| `frontmatter-date-check.yml` | Blocks PRs if `last_updated` frontmatter is unchanged on modified files |
| `vale-style.yml` | Vale prose linting |
| `freshness-check.yml` | Weekly scan for stale documentation |
| `link-checker.yml` | Broken link detection |

### Configuration Files

Copy these to your repository root:

| File | Purpose |
|------|---------|
| `.pre-commit-config.yaml` | Pre-commit hooks: docs enforcement, markdownlint, hygiene checks |
| `.markdownlint-cli2.yaml` | Markdownlint rules with sensible defaults |

### Git Hooks

See [scripts/git-hooks/](../scripts/git-hooks/) for documentation enforcement hooks:

| File | Purpose |
|------|---------|
| `doc-enforcement.conf` | Configuration: file patterns, exempt paths, enforcement mode |
| `doc-enforcement-lib.sh` | Shared logic: scope resolution, meaningful diff detection |
| `pre-commit` | Pre-commit hook entry point |
| `post-commit-audit` | Logs `--no-verify` bypasses for audit trail |
| `install.sh` | One-command hook installer |

### Portal Configuration

See [portal/](./portal/) directory for MkDocs configuration templates.

## Usage

### Quick Setup (Recommended)

```bash
# From your repository root, with this standard as a submodule at docs/standards/
bash docs/standards/init.sh --team
```

This copies templates, scripts, hooks, pre-commit config, and CI workflows.

### Manual Setup

1. Copy the relevant templates to your repository
2. Copy `scripts/git-hooks/` for documentation enforcement
3. Copy `.pre-commit-config.yaml` and `.markdownlint-cli2.yaml` to your root
4. Copy CI workflows from `templates/ci-cd/` to `.github/workflows/`
