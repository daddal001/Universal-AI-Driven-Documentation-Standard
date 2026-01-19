---
title: "Quick Start for Open Source Projects"
type: "getting-started"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-01-12"
last_updated: "2025-01-12"
version: "1.1.0"
---

# Quick Start for Open Source Projects

> **Time: 2 minutes** | **Files created: 3** | **Contributor-ready**

## Use This If

- ✅ You're building an **open source project**
- ✅ You want **community contributions**
- ✅ You need **contributor guidelines** (CONTRIBUTING.md)
- ✅ You want to track **version history** (CHANGELOG.md)

**Not you?** Try [Solo](./QUICK_START_SOLO.md) | [Team](./QUICK_START_TEAM.md) | [Enterprise](./QUICK_START_ENTERPRISE.md)

---

You're building something open source. You want contributors to find you, understand your project, and submit PRs without hand-holding.

## One Command

```bash
bash docs/standards/init.sh --oss
```

## What You Get

```
my-project/
├── README.md           # Project overview with badges
├── CONTRIBUTING.md     # How to contribute (fork → PR workflow)
└── CHANGELOG.md        # Version history (Keep a Changelog format)
```

## Each File Explained

### README.md

- Project description
- Quick start commands
- Features list
- Links to other docs
- License info

### CONTRIBUTING.md

- Fork/clone/branch workflow
- Development setup
- Code style guidelines
- How to submit PRs

### CHANGELOG.md

- Follows [Keep a Changelog](https://keepachangelog.com/)
- Semantic versioning ready
- Pre-filled with initial release

## Next Steps

1. **Edit README.md** - Add your project description and features
2. **Edit CONTRIBUTING.md** - Update dev setup commands for your stack
3. **Add a LICENSE** - MIT, Apache 2.0, etc.
4. **Push to GitHub** - You're ready for contributors!

## Optional: Add AI Support

Want AI assistants (Claude, Copilot, Cursor) to understand your codebase better?

```bash
# Run the full interactive installer
bash docs/standards/init.sh
# Choose "Minimal" mode
# Say "Yes" to AI agent support
```

This adds:

- `llms.txt` - Machine-readable project summary
- `AGENTS.md` - Rules for AI to follow

## Skip Frontmatter

Don't want YAML headers in your markdown?

```bash
bash docs/standards/init.sh --oss --no-frontmatter
```

## Recommended Additions

For a polished OSS project, consider also adding:

| File | Purpose | Template |
|------|---------|----------|
| `CODE_OF_CONDUCT.md` | Community guidelines | [Contributor Covenant](https://www.contributor-covenant.org/) |
| `SECURITY.md` | Vulnerability reporting | [templates/tier-oss/SECURITY.md](./templates/tier-oss/SECURITY.md) |
| `LICENSE` | Legal terms | Choose at [choosealicense.com](https://choosealicense.com/) |

---

**Philosophy:** Open source projects need docs that help strangers contribute. These three files cover 90% of what you need.
