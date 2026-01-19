---
title: "Frequently Asked Questions"
type: "faq"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-01-12"
last_updated: "2025-01-12"
version: "1.1.0"
---

# Frequently Asked Questions

> Quick answers to common questions about the Universal Documentation Standard.

---

## Getting Started

### 1. Which quick start guide should I use?

**Use this decision matrix:**

| Your Situation | Use This | Time |
|----------------|----------|------|
| Solo dev, side project, <5 engineers | `--solo` | 30 sec |
| Open source project, need contributor guidelines | `--oss` | 2 min |
| Startup/team, 5-50 engineers, need runbooks | `--team` | 5 min |
| Enterprise, 50+ engineers OR compliance needs | Interactive | 15 min |

```bash
# Examples
bash init.sh --solo          # Just README.md
bash init.sh --oss           # README + CONTRIBUTING + CHANGELOG
bash init.sh --team          # Standard + runbooks + AI support
bash init.sh                 # Full interactive setup
```

---

### 2. Do I need YAML frontmatter?

**It depends on your setup:**

- **Solo/OSS mode**: No, use `--no-frontmatter` flag
- **Team mode**: Recommended for document tracking
- **Enterprise**: Yes, required for compliance and automation

Frontmatter enables:

- Automated freshness checking
- Document ownership tracking
- CI/CD validation
- Classification for access control

Skip it with: `bash init.sh --oss --no-frontmatter`

---

### 3. Do I need ALL the templates?

**No!** Templates are "grab what you need."

**Always useful:**

- README.md — Every project needs this
- GETTING_STARTED.md — If you have new developers

**Use when applicable:**

- RUNBOOK.md — If you run services in production
- ARCHITECTURE.md — If your system is complex
- ADR.md — If you make significant technical decisions

**Enterprise only:**

- AUDIT_TRAIL.md — Compliance requirements
- COMPLIANCE_MATRIX.md — Multiple frameworks (SOC2, ISO27001)

---

## Integration

### 4. Can I use Confluence/Notion alongside this?

**Yes!** This standard is complementary, not exclusive.

**Recommended split:**

| Keep in Git | Keep in Confluence/Notion |
|-------------|---------------------------|
| README.md | Meeting notes |
| ARCHITECTURE.md | Product specs |
| ADR.md | Roadmaps |
| RUNBOOK.md | Design mockups |
| API docs | User guides |

**Why Git for these?** They should version with code, be code-reviewed, and survive tool changes.

---

### 5. How do I migrate existing documentation?

**Phased approach:**

1. **Week 1**: Inventory existing docs (spreadsheet of what exists where)
2. **Week 2**: Prioritize by value (critical runbooks first)
3. **Week 3+**: Migrate one category at a time

**Migration tips:**

- Don't try to do everything at once
- Start with incident runbooks (immediate value)
- Use templates as guides, not strict requirements
- Add frontmatter as you migrate

---

### 6. What if my team uses a different folder structure?

**The standard is flexible.** Rename folders to match your conventions:

```
# Instead of:
docs/templates/RUNBOOK.md

# You can use:
documentation/runbooks/template.md
wiki/operations/runbook-template.md
```

**What matters:**

- Templates exist and are findable
- Documentation is version-controlled
- Structure is consistent within your repo

---

## Frontmatter

### 7. What's the difference between type, status, and classification?

| Field | Purpose | Example Values |
|-------|---------|----------------|
| `type` | Document purpose | readme, runbook, adr, guide |
| `status` | Approval state | draft, review, approved, stale |
| `classification` | Sensitivity level | public, internal, confidential |

**Example:**

```yaml
type: "runbook"           # This is an operational procedure
status: "approved"        # It's been reviewed and accepted
classification: "internal" # Only for employees
```

---

### 8. What status values should I use?

| Status | When to Use |
|--------|-------------|
| `draft` | Work in progress, not yet reviewed |
| `review` | Ready for review, awaiting approval |
| `approved` | Reviewed and accepted for use |
| `stale` | Older than 90 days, needs review |
| `deprecated` | No longer recommended, kept for reference |

---

## AI Support

### 9. What are AGENTS.md and llms.txt?

**AGENTS.md** — Instructions for AI coding assistants (Claude, Copilot, Cursor):

- Architecture rules
- Code style guidelines
- Common tasks and how to do them
- What NOT to do

**llms.txt** — Quick context file for AI to understand your project:

- Project overview
- Key technologies
- File structure

**Why both?** llms.txt is a quick summary, AGENTS.md has detailed instructions.

---

### 10. Will this help my AI assistant write better code?

**Yes!** AI assistants work better when they understand:

- Your architecture patterns
- Your naming conventions
- Your testing requirements
- What files NOT to modify

Without guidance, AI makes generic suggestions. With AGENTS.md, it follows YOUR patterns.

---

## Maintenance

### 11. How do I keep documentation from getting stale?

**Automation:**

```bash
# Run weekly in CI/CD
bash scripts/check-freshness.sh docs/

# Will flag docs > 90 days old
```

**Process:**

1. Assign owners to each document (frontmatter `owner:` field)
2. Run freshness check monthly
3. Owners review their stale docs
4. Mark reviewed docs with updated `last_updated`

---

### 12. How often should I review documentation?

| Document Type | Review Frequency |
|---------------|------------------|
| README.md | Every major release |
| RUNBOOK.md | Quarterly |
| ARCHITECTURE.md | When architecture changes |
| ADR.md | Never (they're historical records) |
| API docs | With every API change |

---

## Validation

### 13. Why do the validation scripts fail?

**Common issues:**

| Error | Cause | Fix |
|-------|-------|-----|
| "Missing field: title" | Frontmatter incomplete | Add required field |
| "Invalid status" | Typo or wrong value | Use: draft, review, approved, stale |
| "date: invalid option" | macOS compatibility | Scripts auto-detect, or install coreutils |
| "Directory not found" | Wrong path | Check the path exists |

---

### 14. Can I customize validation rules?

**Yes!** Modify the scripts in `scripts/docs/`:

- Add new required fields: Edit `REQUIRED_FIELDS` array
- Change threshold days: Edit `THRESHOLD_DAYS` variable
- Add custom checks: Add new validation logic

Or use `--minimal` mode for fewer requirements.

---

## Contribution

### 15. How do I contribute to this standard?

**For your organization:**

1. Fork/copy the templates
2. Customize for your needs
3. Submit PRs with improvements

**For the standard itself:**

1. Open an issue with your suggestion
2. Follow the contribution guidelines
3. Submit a PR

We especially welcome:

- Platform compatibility fixes (Windows, macOS)
- New templates for common scenarios
- Better error messages
- Documentation improvements

---

## Quick Reference

### Commands Cheat Sheet

```bash
# Installation
bash init.sh --solo              # Minimal setup
bash init.sh --oss               # OSS project
bash init.sh --team              # Team setup with AI
bash init.sh                     # Full interactive

# Validation
./scripts/validate-frontmatter.sh docs/
./scripts/check-freshness.sh docs/
./scripts/validate-quality.sh docs/

# Help
bash init.sh --help
./scripts/validate-frontmatter.sh --help
```

### Files Cheat Sheet

| File | Purpose |
|------|---------|
| `README.md` | Project overview (start here) |
| `INDEX.md` | Decision tree for choosing your path |
| `QUICK_START_*.md` | Audience-specific guides |
| `init.sh` | Installation script |
| `templates/` | Reusable document templates |
| `scripts/` | Validation and automation |

---

## Still Have Questions?

- 📖 Read the [full documentation](./INDEX.md)
- 💬 Open a [discussion](https://github.com/your-org/universal-docs-standard/discussions)
- 🐛 Report [issues](https://github.com/your-org/universal-docs-standard/issues)
