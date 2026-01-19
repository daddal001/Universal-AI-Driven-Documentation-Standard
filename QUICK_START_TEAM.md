---
title: "Quick Start for Teams & Startups"
type: "getting-started"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-01-12"
last_updated: "2025-01-12"
version: "1.1.0"
---

# Quick Start for Teams & Startups

> **Time: 5-15 minutes** | **Best for: 5-50 engineers** | **Production-ready**

## Use This If

- ✅ You have **5-50 engineers**
- ✅ You need **runbooks** for production services
- ✅ You want **AI coding assistants** to understand your codebase
- ✅ You're onboarding **new developers** regularly

**Not you?** Try [Solo](./QUICK_START_SOLO.md) | [OSS](./QUICK_START_OSS.md) | [Enterprise](./QUICK_START_ENTERPRISE.md)

---

You're a startup or small team. You need docs that help with:

- Onboarding new engineers fast
- Answering "where is X?" questions
- Handling incidents without panic
- Making AI assistants actually useful

## Quick Setup

```bash
# Run the interactive installer
bash docs/standards/init.sh

# Choose: Standard (recommended)
# AI support: Yes
```

## What You Get

```
your-repo/
├── docs/
│   └── templates/
│       ├── README.md              # Service documentation
│       ├── GETTING_STARTED.md     # New dev onboarding
│       ├── RUNBOOK.md             # Incident response
│       ├── ARCHITECTURE.md        # System design
│       ├── ADR.md                 # Decision records
│       └── ...more templates
├── llms.txt                       # AI context file
├── AGENTS.md                      # AI coding rules
└── .github/workflows/
    └── docs-validation.yml        # Automated checks
```

## The 4 Docs You Need First

Don't try to write everything. Start with these:

| Doc | Purpose | Time | Impact |
|-----|---------|------|--------|
| **README.md** | "What is this service?" | 30 min | High |
| **GETTING_STARTED.md** | "How do I run this locally?" | 1 hour | Critical |
| **RUNBOOK.md** | "The site is down, what do I do?" | 1 hour | Critical |
| **ARCHITECTURE.md** | "How does this system work?" | 2 hours | Medium |

## Week 1 Checklist

- [ ] Run `bash docs/standards/init.sh`
- [ ] Copy `docs/templates/README.md` to your service folder
- [ ] Fill in the README with real information
- [ ] Copy and fill `GETTING_STARTED.md`
- [ ] Test: Can a new engineer run the service in 30 minutes?

## Week 2 Checklist

- [ ] Write `RUNBOOK.md` for your most critical service
- [ ] Update `llms.txt` with your actual project details
- [ ] Update `AGENTS.md` with your coding conventions
- [ ] Test: Does Cursor/Copilot give better suggestions?

## AI Assistant Setup

The installer creates two files that help AI understand your codebase:

### llms.txt

```txt
# Your Project Name

> Brief description for AI assistants.

## Quick Facts
- Languages: TypeScript, Python
- Frameworks: Next.js, FastAPI
- API Style: REST with JSON

## Key Patterns
- Authentication: JWT tokens
- Error format: { "error": string, "code": number }
```

### AGENTS.md

```markdown
# Agent Instructions

## Code Standards
- Use async/await for I/O
- Type hints required
- Follow existing patterns

## Restricted Actions
- Don't modify auth code without review
- Don't delete migration files
```

**Result:** AI assistants like Claude and Copilot will follow your conventions.

## Skip What You Don't Need

The installer creates templates. **Delete what you don't need:**

- No compliance requirements? Delete `COMPLIANCE_MATRIX.md`
- No on-call rotation? Delete `ONCALL_GUIDE.md`
- Single service? Delete `SERVICE_CATALOG.md`

## Validation

The installer sets up a GitHub Actions workflow that checks:

- Frontmatter is valid
- Links aren't broken
- Docs aren't stale (90+ days old)

**Start with warnings, not blockers.** Let your team adjust first.

## Common Questions

**Q: Do we need frontmatter on every doc?**
A: For teams, yes—it enables automation. Use `--no-frontmatter` if you want plain markdown.

**Q: How do we keep docs fresh?**
A: The validation script flags docs older than 90 days. Review them monthly.

**Q: What about Confluence/Notion?**
A: This standard is for code-adjacent docs in git. Keep high-level planning in Confluence/Notion.

---

## Next Level: Enterprise

Once you hit 50+ engineers or need compliance (SOC2, GDPR):

```bash
bash docs/standards/init.sh
# Choose: Enterprise
```

See [QUICK_START_ENTERPRISE.md](./QUICK_START_ENTERPRISE.md).

---

**Philosophy:** Startups need docs that reduce "where is X?" questions and help new hires ship on day one. Start small, expand as needed.
