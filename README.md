---
title: "Universal Documentation Standard"
type: "landing"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-01-12"
last_updated: "2026-03-07"
version: "1.3.0"
---

# Universal Documentation Standard

> **Documentation that makes AI coding assistants actually understand your codebase.**
> Works for solo devs, OSS projects, startups, and enterprise teams.

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](./CONTRIBUTING.md)

## Why This Exists

AI coding assistants (Claude, Copilot, Cursor) work better when they understand your codebase. Good documentation isn't just for humans anymore — it's how you teach AI to write better code for your project.

**This standard gives you:**

- **45 modular standards** — Pick what you need, skip what you don't
- **llms.txt + AGENTS.md** — Machine-readable context for AI assistants
- **Pre-commit hooks** — Enforce docs alongside code automatically
- **CI workflows** — Validate documentation quality on every PR
- **Templates & examples** — Copy, fill in, done

## Quick Start

**Not sure which path to take?** Use our [2-minute decision tree](./INDEX.md)

Or choose directly:

| Your Situation | Command | Time |
|----------------|---------|------|
| Solo dev, side project | `bash init.sh --solo` | 30 sec |
| Open source project | `bash init.sh --oss` | 2 min |
| Team (5-50 engineers) | `bash init.sh --team` | 5 min |
| Enterprise / Compliance | `bash init.sh` | 10 min |

```bash
# Examples
cd docs/standards
bash init.sh --solo    # Just README.md
bash init.sh --oss     # README + CONTRIBUTING + CHANGELOG
bash init.sh --team    # Full setup: templates + hooks + workflows
bash init.sh --help    # See all options
```

### Add as a Git Submodule

```bash
git submodule add https://github.com/daddal001/Universal-AI-Driven-Documentation-Standard.git docs/standards
git submodule update --init --recursive
bash docs/standards/init.sh --team
```

To pull updates later:

```bash
git submodule update --remote --merge
```

## What You Get

| Mode | What's Copied | Best For |
|------|---------------|----------|
| `--solo` | README.md | Side projects, hackathons |
| `--oss` | README, CONTRIBUTING, CHANGELOG | Open source projects |
| `--team` | + Templates, scripts, hooks, CI workflows, pre-commit config | Teams, startups |
| Enterprise | + Compliance, audit trails | Regulated industries |

## Automated Documentation Enforcement

**The killer feature:** code changes that skip documentation get caught automatically — at commit time and in CI.

### Pre-commit Hooks

The `--team` mode installs a **scope-aware documentation enforcement hook**. When a developer changes code in `services/auth/`, the hook checks for a corresponding doc update in `services/auth/` (same scope). No more "I'll write docs later."

```bash
# Install hooks
bash scripts/git-hooks/install.sh

# What happens when you commit code without docs:
$ git commit -m "Add login endpoint"
Doc-enforcement: FAIL
  Changed: services/auth/src/login.ts
  Scope:   services/auth/ (nearest README.md)
  Missing: No .md file changed in services/auth/
  Fix:     Update services/auth/README.md or add --no-verify to bypass
```

Works with **any repo structure** — monorepos, multi-service repos, single-app repos. The hook walks up the directory tree to find the nearest README.md and uses that as the documentation scope.

### CI Workflows

Copy the GitHub Actions workflows to validate docs on every PR:

```bash
# Copy all workflows at once
cp docs/standards/templates/ci-cd/*.yml .github/workflows/
```

| Workflow | What It Does |
|----------|-------------|
| `docs-validation.yml` | Frontmatter, structure, links, markdownlint, Vale |
| `documentation-check.yml` | Blocks PRs that change code without updating docs |
| `frontmatter-date-check.yml` | Blocks PRs if `last_updated` is unchanged on modified files |
| `freshness-check.yml` | Weekly scan for docs older than 90 days |

### Markdownlint + Pre-commit

The repo includes ready-to-use configs:

| File | What It Does |
|------|-------------|
| `.pre-commit-config.yaml` | Docs enforcement, markdownlint with `--fix`, trailing whitespace, YAML checks |
| `.markdownlint-cli2.yaml` | Sensible defaults — 13 rules disabled to avoid false positives |

## Features

### For AI Assistants

- **llms.txt** — Project context that AI tools can parse
- **AGENTS.md** — Coding rules AI should follow
- **Structured schemas** — Config, errors, and architecture in machine-readable formats
- Works with Claude, Copilot, Cursor, and others

### For Humans

- **45 modular standards** — Pick what you need
- **19 real-world examples** — See what good docs look like
- **Ready-to-use templates** — Just fill in the blanks
- **Validation scripts** — Catch problems automatically

### For Teams

- **Pre-commit hooks** — Enforce docs at commit time
- **CI workflows** — Validate on every PR
- **Decision tree** — Know exactly which docs you need
- **Adoption playbook** — 12-week rollout guide

## Documentation Structure

```
docs/standards/
├── 00-45*.md                  # 45 modular standards
├── templates/                  # Copy-paste ready templates
│   ├── tier-oss/              # Open source essentials
│   ├── tier-1-system/         # Architecture, APIs, ADRs, Config, Errors
│   ├── tier-2-operational/    # Runbooks, on-call guides, SLOs
│   ├── tier-enterprise/       # Compliance, audit trails
│   └── ci-cd/                 # GitHub Actions workflows
├── examples/                   # 19 real-world examples
├── scripts/
│   ├── git-hooks/             # Docs enforcement hooks
│   └── docs/                  # Validation scripts
├── .pre-commit-config.yaml    # Pre-commit configuration
└── .markdownlint-cli2.yaml    # Markdownlint rules
```

## Quick Links

| I want to... | Go here |
|--------------|---------|
| Start in 30 seconds | Run `bash init.sh --solo` |
| Enforce docs in my team | [scripts/git-hooks/README.md](./scripts/git-hooks/README.md) |
| Add CI doc checks | [templates/ci-cd/README.md](./templates/ci-cd/README.md) |
| See what good docs look like | [Examples](./examples/) |
| Set up AI agent support | [04-AI_AGENTS.md](./04-AI_AGENTS.md) |
| Choose which docs I need | [INDEX.md](./INDEX.md) |
| Understand the philosophy | [01-PHILOSOPHY.md](./01-PHILOSOPHY.md) |

## Options

### Skip YAML Frontmatter

Don't want metadata headers? Add `--no-frontmatter`:

```bash
bash docs/standards/init.sh --oss --no-frontmatter
```

### Just Copy a Template

Don't want to run a script? Copy directly:

- [Copy-Paste README](./examples/COPY_PASTE_README.md) — Ready to use

## FAQ

**Q: Is this overkill for my small project?**
A: Use `--solo` mode. You'll get one README.md file, nothing more.

**Q: Do I need all 45 standards?**
A: No. Start with what you need. Most projects use 3-5.

**Q: Does this work with my existing docs?**
A: Yes. The installer won't overwrite existing files.

**Q: What about pre-commit hooks — will they break my workflow?**
A: The docs enforcement hook only runs on code changes. Pure documentation PRs, test files, and CI config changes are exempt. You can always bypass with `--no-verify` (logged for audit).

**Q: What's the llms.txt thing?**
A: It's a machine-readable summary of your project. AI assistants read it to understand your codebase context. [Learn more](./04-AI_AGENTS.md)

## Contributing

We welcome contributions! See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

CC BY 4.0 - Use it, modify it, share it. Just give credit.

---

**Made for the age of AI-assisted development.**
*Good docs help humans. Great docs help AI help humans.*
