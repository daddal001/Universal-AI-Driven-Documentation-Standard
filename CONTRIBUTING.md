---
title: "Contributing to Documentation"
type: "guide"
status: "approved"
owner: "@documentation-maintainer"
created: "2025-12-13"
last_updated: "2025-12-13"
version: "1.0.0"
---

# Contributing to Documentation

Guide for contributing to documentation in this repository.

---

> **Note on Owner References:** Throughout these standards, you will see `@documentation-maintainer` used as an example owner. In your project, replace this with your actual GitHub team handle (e.g., `@backend-team`, `@frontend-leads`) or your username.

## Quick Start

1. **Find the right template** in `templates/`
2. **Copy and fill** in the template
3. **Run validation**: `bash scripts/validate-frontmatter.sh .`
4. **Submit PR** with appropriate labels

---

## Templates Available

| Template | Use For |
|----------|---------|
| `templates/README.md` | Service READMEs |
| `templates/RUNBOOK.md` | Operational runbooks |
| `templates/ADR.md` | Architecture decision records |
| `templates/POSTMORTEM.md` | Incident postmortems |
| `templates/API_SPEC.yaml` | OpenAPI specifications |
| `templates/CHANGELOG.md` | Version history |

---

## Review Process

| Label | Reviewer | Focus |
|-------|----------|-------|
| `doc-review-technical` | Subject Matter Expert | Accuracy |
| `doc-review-audience` | New team member | Clarity |
| `doc-review-writing` | Tech writer / Vale | Style |

### Review Checklist

Reviewers should verify:

- [ ] Frontmatter is complete and valid
- [ ] All file paths/links work
- [ ] Code examples are copy-paste ready
- [ ] No placeholder text (foo, bar, example)
- [ ] Follows style guide (active voice, present tense)

---

## Style Guide Summary

- **Voice:** Active ("Run the command" not "The command should be run")
- **Tense:** Present ("This function returns" not "This function will return")
- **Person:** Second ("You can configure" not "Users can configure")
- **Jargon:** Define on first use or link to Glossary

> Full style guide: [11-STYLE_GUIDE.md](./11-STYLE_GUIDE.md)

---

## Validation Commands

```bash
# Run all validations
bash scripts/validate-frontmatter.sh .
bash scripts/validate-structure.sh .
bash scripts/check-freshness.sh .
bash scripts/validate-style.sh .

# Check specific file
bash scripts/validate-frontmatter.sh ./my-document.md
```

---

## Common Issues

| Issue | Solution |
|-------|----------|
| Missing frontmatter | Add YAML block at top of file |
| Invalid `type` | Use: standard, guide, reference, runbook, tutorial |
| Invalid `status` | Use: draft, review, approved, stale, deprecated |
| Broken links | Check file paths, use relative links |
| Vale errors | Run `vale --config=.vale.ini docs/` |

---

## Contributing to the Open Source Standards

This documentation standard is open source under CC BY 4.0. We welcome contributions!

### Types of Contributions

| Type | How to Contribute |
|------|-------------------|
| 🐛 **Bug Reports** | Open an issue describing the problem |
| 💡 **Feature Requests** | Open an issue with your suggestion |
| 📝 **Documentation Fixes** | Submit a PR with corrections |
| 🌍 **Translations** | Fork and create localized versions |
| 🔧 **New Standards** | Propose via issue first, then PR |

### Pull Request Process

1. **Fork** the repository
2. **Create a branch** (`git checkout -b improve-api-docs`)
3. **Make changes** following existing style
4. **Run validation** (`bash scripts/validate-frontmatter.sh .`)
5. **Submit PR** with clear description
6. **Respond to feedback**

### Questions?

- **GitHub Issues:** [Open an issue](../../issues)
- **Discussions:** [Start a discussion](../../discussions)
- **Full Standards:** See [INDEX.md](./INDEX.md)
