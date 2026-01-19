---
title: "Quick Start for Enterprise"
type: "getting-started"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-01-12"
last_updated: "2025-01-12"
version: "1.1.0"
---

# Quick Start for Enterprise

> **Time: 1-2 hours setup, 12-week rollout** | **Best for: 50+ engineers** | **Compliance-ready**

## Use This If

- ✅ You have **50+ engineers** OR multiple teams
- ✅ You need **compliance documentation** (SOC2, ISO27001, GDPR, HIPAA)
- ✅ You require **audit trails** and governance
- ✅ You need documentation that **scales** across many services

**Not you?** Try [Solo](./QUICK_START_SOLO.md) | [OSS](./QUICK_START_OSS.md) | [Team](./QUICK_START_TEAM.md)

---

You're at a larger organization. You need documentation that:

- Survives audits (SOC2, ISO27001, GDPR)
- Scales across 50+ services
- Has clear ownership and governance
- Enforces standards automatically

## Important: Set Expectations

This standard provides **documentation templates and validation**, not:

- Audit evidence collection (use Drata, Vanta, or similar)
- Access control/SSO (integrate with your identity provider)
- Confluence migration (that's a separate project)

**What it does:** Gives you a consistent documentation framework that supports compliance efforts.

## Setup

```bash
# Run the interactive installer
bash docs/standards/init.sh

# Choose: Enterprise
# AI support: Yes
```

## What You Get

```
your-repo/
├── docs/
│   └── templates/
│       ├── # All Standard templates, plus:
│       ├── COMPLIANCE_MATRIX.md      # Control mapping
│       ├── AUDIT_TRAIL.md            # Change documentation
│       ├── DATA_CLASSIFICATION.md    # Data sensitivity levels
│       └── VENDOR_DOCUMENTATION.md   # Third-party docs
├── scripts/
│   └── docs/
│       ├── validate-frontmatter.sh   # Metadata validation
│       └── check-freshness.sh        # Staleness detection
├── llms.txt
├── AGENTS.md
└── .github/workflows/
    └── docs-validation.yml
```

## 12-Week Adoption Playbook

See [00-ADOPTION_PLAYBOOK.md](./00-ADOPTION_PLAYBOOK.md) for the full guide. Summary:

| Phase | Weeks | Focus |
|-------|-------|-------|
| **Learn** | 1-2 | Read standards, audit current docs |
| **Build** | 3-4 | Create 5 key documents |
| **Enforce** | 5-8 | Git hooks, CI/CD, soft rollout |
| **Scale** | 9-12 | Team training, legacy migration |

## Compliance Integration

### What This Standard Helps With

| Framework | How We Help |
|-----------|-------------|
| **SOC2** | Document controls, change management, incident response |
| **ISO27001** | Policy templates, risk documentation structure |
| **GDPR** | Data processing records template, privacy documentation |

### What You Still Need

| Requirement | Solution |
|-------------|----------|
| Audit evidence | Drata, Vanta, Secureframe |
| Access control | Your SSO + RBAC |
| Audit logs | Your logging infrastructure |
| Signed approvals | Git commit signing + PR reviews |

## Governance Model

### CODEOWNERS

Set up ownership in `.github/CODEOWNERS`:

```
# Documentation ownership
docs/compliance/     @security-team
docs/architecture/   @platform-team
docs/runbooks/       @sre-team
services/*/README.md @service-owners
```

### Frontmatter Requirements

Enterprise mode uses **strict** frontmatter validation:

```yaml
---
title: "Document Title"           # Required
type: "runbook"                   # Required (from valid list)
status: "approved"                # Required
classification: "internal"        # Required (public/internal/confidential/restricted)
owner: "@team-name"               # Required
created: "2025-01-12"             # Required
last_updated: "2025-01-12"        # Required
version: "1.0.0"                  # Required
---
```

### Review Cadence

| Classification | Review Frequency |
|---------------|------------------|
| `restricted` | Quarterly |
| `confidential` | Quarterly |
| `internal` | Every 6 months |
| `public` | Annually |

## Validation Scripts

### Frontmatter Validation

```bash
# Strict mode for enterprise
bash scripts/docs/validate-frontmatter.sh docs/ --strict
```

Checks:

- All required fields present
- Valid values for type, status, classification
- Dates are valid format
- Owner exists in CODEOWNERS

### Freshness Check

```bash
bash scripts/docs/check-freshness.sh docs/ --days 90
```

Flags docs not updated in 90+ days.

## CI/CD Integration

The installer creates `.github/workflows/docs-validation.yml`:

```yaml
# Runs on every PR
- Validates frontmatter
- Checks for broken links
- Flags stale documents
- Reports classification violations
```

**Recommendation:** Start with warnings (non-blocking), then enable blocking after 4 weeks.

## Migration Strategy

### From Confluence

1. **Don't migrate everything** - Only active, code-related docs
2. **Parallel run** - Keep Confluence for 6 months
3. **Link, don't copy** - Reference Confluence for historical context
4. **Prioritize** - Start with runbooks and architecture docs

### From No Documentation

1. **Inventory** - List all services
2. **Prioritize** - Critical services first
3. **Template** - Use our templates, don't write from scratch
4. **Incremental** - One service per week

## Common Enterprise Questions

**Q: How do we handle multi-region documentation?**
A: Use the same structure per region. Add `region: "us-east-1"` to frontmatter if needed.

**Q: What about translations?**
A: See [09-LOCALIZATION.md](./09-LOCALIZATION.md). Use `locale/` subdirectories.

**Q: How do we integrate with our internal wiki?**
A: Code-adjacent docs stay in git. High-level planning stays in wiki. Link between them.

**Q: Can we customize the validation rules?**
A: Yes. Edit `scripts/docs/validate-frontmatter.sh` to match your requirements.

**Q: What about service mesh documentation?**
A: Use [21-SERVICE_CATALOG.md](./21-SERVICE_CATALOG.md) for service registry patterns.

## Realistic Expectations

### What Works Well

- Consistent structure across teams
- Automated staleness detection
- Clear ownership via CODEOWNERS
- AI assistants understand your codebase

### What Requires Effort

- Initial adoption (expect pushback)
- Keeping docs fresh (needs process)
- Compliance evidence (needs separate tools)
- Legacy migration (budget 3-6 months)

### What This Won't Solve

- Cultural resistance to documentation
- Understaffed technical writing
- Tool sprawl (Confluence + Notion + Git)
- Perfect audit compliance

---

## Support

- Full standard: [INDEX.md](./INDEX.md)
- Adoption guide: [00-ADOPTION_PLAYBOOK.md](./00-ADOPTION_PLAYBOOK.md)
- Governance: [07-GOVERNANCE.md](./07-GOVERNANCE.md)
- Compliance: [24-SECURITY_COMPLIANCE.md](./24-SECURITY_COMPLIANCE.md)

---

**Philosophy:** Enterprise documentation is about consistency and auditability. This standard gives you structure; your team provides the content and discipline.
