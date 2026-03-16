# Contributing

## The basics

1. Find the right template in `templates/`
2. Copy it, fill it in
3. Run validation: `bash scripts/validate-frontmatter.sh .`
4. Open a PR

That's it for most contributions. Read on if you want the details.

## Templates

| Template | Use for |
|---|---|
| `templates/README.md` | Service READMEs |
| `templates/RUNBOOK.md` | Operational runbooks |
| `templates/ADR.md` | Architecture decision records |
| `templates/POSTMORTEM.md` | Incident postmortems |
| `templates/API_SPEC.yaml` | OpenAPI specifications |
| `templates/CHANGELOG.md` | Version history |

## Style rules

- **Active voice.** "Run the command" not "The command should be run"
- **Present tense.** "This function returns" not "This function will return"
- **Second person.** "You can configure" not "Users can configure"
- **Define jargon** on first use or link to the [Glossary](GLOSSARY.md)

Full style guide: [11-STYLE_GUIDE.md](11-STYLE_GUIDE.md)

## Validation

```bash
# Run everything
bash scripts/validate-frontmatter.sh .
bash scripts/validate-structure.sh .
bash scripts/check-freshness.sh .
bash scripts/validate-style.sh .

# Check a specific file
bash scripts/validate-frontmatter.sh ./my-document.md
```

## Review process

PRs get reviewed for three things:

| Label | Reviewer | What they check |
|---|---|---|
| `doc-review-technical` | Subject matter expert | Is it accurate? |
| `doc-review-audience` | New team member | Is it clear? |
| `doc-review-writing` | Tech writer / Vale | Is it well-written? |

Before you submit, check these yourself:

- Frontmatter is complete and valid
- All file paths and links work
- Code examples are copy-paste ready (not `foo`, `bar`, `example`)
- Active voice, present tense

## Common issues

| Issue | Fix |
|---|---|
| Missing frontmatter | Add YAML block at top of file |
| Invalid `type` | Use: standard, guide, reference, runbook, tutorial |
| Invalid `status` | Use: draft, review, approved, stale, deprecated |
| Broken links | Use relative links, check file paths |
| Vale errors | `vale --config=.vale.ini docs/` |

## Types of contributions

| Type | How |
|---|---|
| Bug reports | Open an issue describing the problem |
| Feature requests | Open an issue with your suggestion |
| Documentation fixes | Submit a PR with corrections |
| Translations | Fork and create localised versions |
| New standards | Open an issue first to discuss scope, then PR |

New standards: please open an issue before writing the whole thing. This project is opinionated on purpose — not every standard belongs here, and it's better to discuss fit before you invest the time.

## PR process

1. Fork the repo
2. Create a branch (`git checkout -b improve-api-docs`)
3. Make your changes following the existing style
4. Run validation (`bash scripts/validate-frontmatter.sh .`)
5. Open a PR with a clear description of what you changed and why
6. Respond to feedback

## Questions?

- [Open an issue](../../issues)
- [Start a discussion](../../discussions)
- [Browse the full standards index](INDEX.md)

> **Note:** Throughout these standards, `@documentation-maintainer` is used as a placeholder owner. Replace it with your actual GitHub team handle (e.g., `@backend-team`) or your username.
