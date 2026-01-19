---
title: "CLI & Tooling Documentation"
type: "standard"
status: "approved"
owner: "@platform-team"
classification: "public"
created: "2025-12-09"
last_updated: "2025-12-09"
version: "1.0.0"
---

# CLI & Tooling Documentation

> **Goal:** Ensure every script and CLI tool has clear, consistent, and copy-pasteable documentation.

---

## 1. The Help Command (`--help`)

The first line of documentation is the tool itself. Every script MUST implement a `-h` or `--help` flag.

**Standard Output Format:**

```text
Usage: <tool_name> [OPTIONS] [COMMAND]

<Description of what the tool does>

Options:
  -c, --config <file>    Path to configuration file (default: ./config.yaml)
  -v, --verbose          Enable verbose logging
  -h, --help             Show this help message and exit
  --version              Show version information

Commands:
  build                  Build the project artifacts
  deploy                 Deploy to target environment
  rollback               Revert to previous version
```

---

## 2. Command Reference Structure

For the Markdown documentation (e.g., in `docs/tools/`), use this strict structure:

### Usage Syntax

Use the following notation conventions:

| Symbol | Meaning | Example |
|--------|---------|---------|
| `[]` | Optional | `[--verbose]` |
| `<>` | Required | `<filename>` |
| `|` | Exclusive OR | `start | stop` |
| `...` | Repeating | `<file>...` |

**Example:**

```bash
usage: deploy.sh [-f] <environment> [services...]
```

### Exit Codes

Document non-zero exit codes so CI/CD pipelines can handle errors gracefully.

| Code | Meaning | Recovery |
|------|---------|----------|
| `0` | Success | N/A |
| `1` | Generic Error | Check logs |
| `2` | Bad Configuration | Fix config file |
| `127` | Command not found | Check dependencies |

---

## 3. Interactive Prompts

If your tool is interactive, document the prompts and how to bypass them for automation (CI/CD).

**Requirement:**
Every interactive script MUST have a non-interactive mode (e.g., `--yes`, `--force`, or `--non-interactive`).

**Documentation Example:**

> **Interactive Mode:**
> By default, the script asks for confirmation:
>
> ```text
> ? Are you sure you want to delete production database? (y/N)
> ```
>
> **Automation Mode:**
> To skip confirmation in CI/CD:
>
> ```bash
> ./nuke-db.sh --force --environment prod
> ```

---

## 4. Code Block Standards

* **Prompt Symbol:** Use `$` for user input lines to distinguish from output.
* **Comments:** Use `#` for explanations within the block.

**Bad:**

```bash
git checkout main
Switched to branch 'main'
git pull
Already up to date.
```

**Good:**

```bash
# Switch to main branch
$ git checkout main
Switched to branch 'main'

# Update
$ git pull
Already up to date.
```

---

## 5. Related Documents

| Document | Purpose |
|----------|---------|
| [Style Guide](./11-STYLE_GUIDE.md) | Syntax formatting rules |
| [Quality](./05-QUALITY.md) | Verification steps |

---

**Previous:** [14 - Visuals](./14-VISUALS.md)
**Next:** [16 - Release Notes](./16-RELEASE_NOTES.md)
