---
title: "Universal Documentation Standard"
type: "landing"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-01-12"
last_updated: "2025-01-12"
version: "1.1.0"
---

# Universal Documentation Standard

> **Documentation that makes AI coding assistants actually understand your codebase.**
> Works for solo devs, OSS projects, startups, and enterprise teams.

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](./CONTRIBUTING.md)

## Why This Exists

AI coding assistants (Claude, Copilot, Cursor) work better when they understand your codebase. Good documentation isn't just for humans anymore—it's how you teach AI to write better code for your project.

**This standard gives you:**

- **llms.txt** - A machine-readable project summary for AI assistants
- **AGENTS.md** - Rules and patterns for AI to follow in your codebase
- **Templates** - Pre-built docs that work for humans AND machines

## Quick Start

**Not sure which path to take?** Use our [2-minute decision tree →](./INDEX.md)

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
bash init.sh --team    # Full setup with AI support + runbooks
bash init.sh --help    # See all options
```

## What You Get

| Mode | Files Created | Best For |
|------|---------------|----------|
| `--solo` | README.md | Side projects, hackathons |
| `--oss` | README, CONTRIBUTING, CHANGELOG | Open source projects |
| Interactive | + Templates, llms.txt, AGENTS.md | Teams, startups |
| Enterprise | + Compliance, audit trails | Regulated industries |

## Features

### For AI Assistants

- **llms.txt** - Project context that AI tools can parse
- **AGENTS.md** - Coding rules AI should follow
- Works with Claude, Copilot, Cursor, and others

### For Humans

- **40 modular standards** - Pick what you need
- **Ready-to-use templates** - Just fill in the blanks
- **Validation scripts** - Catch problems automatically

### For Teams

- **Decision tree** - Know exactly which docs you need
- **Adoption playbook** - 12-week rollout guide
- **CI/CD integration** - Automate quality checks

## Documentation Structure

```
docs/standards/
├── 00-ADOPTION_PLAYBOOK.md    # How to roll this out
├── 01-PHILOSOPHY.md           # Why documentation matters
├── 04-AI_AGENTS.md            # AI-specific guidance ⭐
├── templates/                  # Copy-paste ready templates
│   ├── tier-oss/              # Open source essentials
│   ├── tier-1-system/         # Architecture, APIs, ADRs
│   ├── tier-2-operational/    # Runbooks, on-call guides
│   └── tier-enterprise/       # Compliance, audit trails
├── examples/                   # Real-world examples
└── scripts/                    # Validation automation
```

## Quick Links

| I want to... | Go here |
|--------------|---------|
| Start in 30 seconds | Run `bash init.sh --solo` |
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

- [Copy-Paste README](./examples/COPY_PASTE_README.md) - Ready to use

## FAQ

**Q: Is this overkill for my small project?**
A: Use `--solo` mode. You'll get one README.md file, nothing more.

**Q: Do I need all 40 standards?**
A: No. Start with what you need. Most projects use 3-5.

**Q: Does this work with my existing docs?**
A: Yes. The installer won't overwrite existing files.

**Q: What's the llms.txt thing?**
A: It's a machine-readable summary of your project. AI assistants read it to understand your codebase context. [Learn more](./04-AI_AGENTS.md)

## Contributing

We welcome contributions! See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

CC BY 4.0 - Use it, modify it, share it. Just give credit.

---

**Made for the age of AI-assisted development.**
*Good docs help humans. Great docs help AI help humans.*
