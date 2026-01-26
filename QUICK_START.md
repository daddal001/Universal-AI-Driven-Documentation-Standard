---
title: "Quick Start Guide"
type: "guide"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2025-12-14"
version: "1.0.0"
---

# Quick Start Guide: Universal Documentation Standards

> **From Zero to Enterprise-Grade Documentation in < 60 Seconds.**

## Quick Setup Options

### Option 1: Dev Container (Recommended)

If you are starting a new project or onboarding:

1. Create a `.devcontainer` directory using the standard templates.
2. Reopen VS Code in the container.
3. The environment (including documentation tools) will be auto-configured.

### Option 2: The "Magic" Installer

We provide a drop-in installer that analyzes your project and sets up the perfect documentation structure automatically.

### 1. Run the Installer

Run this command from the root of your repository:

```bash
# If you have cloned this repo as a submodule
bash docs/standards/init.sh
```

**What it does:**

- Detects your repo type and suggests the right doc set
- Copies templates into your repo (no overwrite)
- Optionally adds `llms.txt` and `AGENTS.md` for AI assistants
- Can add validation scripts and CI workflow

### 2. Choose Your Path

Pick the setup that matches your team and time:

| You Are | Time | Command | Guide |
|---------|------|---------|-------|
| Solo developer | 30 sec | `bash docs/standards/init.sh --solo` | [QUICK_START_SOLO.md](./QUICK_START_SOLO.md) |
| OSS maintainer | 2 min | `bash docs/standards/init.sh --oss` | [QUICK_START_OSS.md](./QUICK_START_OSS.md) |
| Startup/Team | 5-15 min | `bash docs/standards/init.sh` | [QUICK_START_TEAM.md](./QUICK_START_TEAM.md) |
| Enterprise | 1-2 hours | `bash docs/standards/init.sh` (Enterprise) | [QUICK_START_ENTERPRISE.md](./QUICK_START_ENTERPRISE.md) |

If you cloned this repo directly (not as a submodule), run the same commands from the repo root by replacing `docs/standards/init.sh` with `init.sh`.

### 3. Verify and Customize

1. Open the generated files and replace placeholders with real data.
2. Keep only the templates you need; delete the rest.
3. Optional: run validation scripts if you enabled them.

```bash
# Example validations
bash docs/standards/scripts/validate-frontmatter.sh docs/
bash docs/standards/scripts/check-freshness.sh docs/ --days 90
```

### Where to Go Next

- Decision tree for the right mode: [INDEX.md](./INDEX.md)
- Examples of finished docs: [examples/README.md](./examples/README.md)
- Full standard list: [INDEX.md](./INDEX.md)
