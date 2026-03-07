---
title: "Localization Standard"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-09"
last_updated: "2026-03-07"
version: "1.2.0"
---

# Localization Standard

> **Goal:** Ensure documentation is "World Ready" by design, supporting global audiences through robust internationalization (i18n) and localization (l10n) strategies.

---

## 1. i18n Readiness Principles

Before translation begins, documentation must be *internationalized*.

* **Code Separation:** Never hardcode text inside diagrams or screenshots. Use SVGs with editable text layers or keep text in captions.
* **Expansion Room:** Design layouts (tables, callouts) to accommodate 30-40% text expansion (common when translating English to German/Spanish/Arabic).
* **Date/Time Formats:** Use ISO 8601 (`YYYY-MM-DD`) strictly. Avoid "01/02/2024" (ambiguous).
* **Cultural Neutrality:** Avoid idioms ("hit it out of the park"), sports metaphors, or region-specific references.
* **Number Formats:** Use locale-agnostic formats in source — `1000` not `1,000` (comma vs period separator varies by locale).
* **Pluralization:** Design strings for plural rules. English has 2 forms (singular/plural), Arabic has 6, Chinese has 1. Use ICU MessageFormat or equivalent.

## 2. Directory Structure Strategy

We adopt a **Directory-Based** strategy for localization. Do NOT use file suffixes (e.g., `README.es.md`).

**Why?**

* **Clean separation of assets/images per language if text is embedded.**
* **Easier to configure static site generators (MkDocs/Hugo) with language roots.**
* **Allows distinct `CODEOWNERS` for specific languages.**

**Standard Pattern:**

```text
docs/
├── en/ (English - Source of Truth)
│   ├── getting-started.md
│   └── images/
├── es/ (Spanish)
│   ├── getting-started.md
│   └── images/
├── ja/ (Japanese)
│   ├── getting-started.md
│   └── images/
└── ar/ (Arabic - RTL)
    ├── getting-started.md
    └── images/
```

> **Note:** The `en/` folder is the **canonical source**. Changes are made there first, then propagated to other directories.

## 3. RTL and CJK Considerations

### Right-to-Left (RTL) Languages

Languages like Arabic, Hebrew, and Farsi require:

* **Bidirectional text handling:** Use `dir="rtl"` attributes on generated HTML. Static site generators (MkDocs, Docusaurus) support `direction` in config.
* **Mirrored layouts:** Navigation, breadcrumbs, and tables should mirror. CSS `logical properties` (`margin-inline-start` instead of `margin-left`) handle this.
* **Code blocks remain LTR:** Code, file paths, and terminal output stay left-to-right even in RTL documents.

### CJK (Chinese, Japanese, Korean)

* **No word spacing:** CJK text does not use spaces between words. Line-breaking rules differ — avoid fixed-width layouts.
* **Font fallback chains:** Specify CJK fonts in CSS: `font-family: "Noto Sans", "Noto Sans CJK SC", sans-serif;`
* **Vertical text:** Rare in technical docs. Do not use unless required by the audience.

## 4. Translation Workflow

1. **Freeze:** The English version must be "Stable" or "Approved" before translation begins.
2. **Context:** Provide a "Translation Kit" if working with external vendors:
    * **Glossary of Terms (e.g., "Do not translate 'Pod', 'Service'").**
    * **Descriptions of UI elements (e.g., "Button label", "Error message").**
    * **Max string lengths for UI-constrained text.**
3. **Validation:** Localized docs must pass the same linting/structure checks as English docs.
4. **Back-translation check:** For critical docs (security, compliance), have a second translator translate back to English to verify accuracy.

## 5. Translation Management Platforms

| Platform | Type | Best For |
|----------|------|----------|
| **Crowdin** | SaaS | OSS projects (free for open source), GitHub/GitLab integration |
| **Weblate** | Self-hosted / SaaS | Teams wanting full control, Git-native workflow |
| **Transifex** | SaaS | Large enterprises, API-first workflow |
| **Lokalise** | SaaS | Mobile-heavy teams, screenshot context |

### Recommended Workflow (Crowdin/Weblate)

```text
1. Push English source to main branch
2. Platform detects changes, creates translation tasks
3. Translators work in platform UI (with glossary + TM)
4. Platform opens PR with translated files
5. CI validates structure + linting on translated PR
6. Merge after review
```

## 6. Pseudolocalization

Before investing in real translations, use pseudolocalization to catch i18n bugs early.

**What it does:** Replaces English text with accented characters and padding to simulate translation.

| Technique | Example | Tests For |
|-----------|---------|-----------|
| Accented chars | `[Ŝéttîñgš]` | Character encoding, font support |
| Expansion padding | `[Ŝéttîñgš____]` | Layout overflow, truncation |
| RTL markers | `[‫Ŝéttîñgš‬]` | Bidirectional text handling |
| Brackets | `[Ŝéttîñgš]` | Untranslated string detection |

**Tools:** `pseudo-localization` (npm), ICU4J `PseudoLocale`, or built-in Crowdin pseudo-locale.

## 7. Automation and CI

* **Sync Checks:** CI should flag if `es/doc.md` is significantly older (~5 commits behind) than `en/doc.md`.
* **Asset Checks:** Verify that all images present in `en/` exist in other locales (or fallback to `en/`).
* **Structure Parity:** Validate that translated files have the same heading structure as the English source.
* **Translation Coverage:** Track percentage of translated strings per locale. Set a minimum threshold (e.g., 80%) before publishing a locale.

### Example CI Check (GitHub Actions)

```yaml
- name: Check translation freshness
  run: |
    for locale in es ja ar; do
      for file in docs/en/**/*.md; do
        target="docs/$locale/${file#docs/en/}"
        if [ -f "$target" ]; then
          en_date=$(git log -1 --format=%ct "$file")
          loc_date=$(git log -1 --format=%ct "$target")
          if [ "$en_date" -gt "$loc_date" ]; then
            echo "::warning::$target is older than $file"
          fi
        else
          echo "::warning::Missing translation: $target"
        fi
      done
    done
```

## 8. Translation Memory and Glossaries

* **Translation Memory (TM):** Stores previously translated segments. Reuse rate typically reaches 40-60% for technical docs.
* **Glossary:** Mandatory for technical projects. Include:
  * Terms that must NOT be translated (product names, API endpoints, CLI commands)
  * Terms with specific translations (e.g., "deploy" → "desplegar" in Spanish, not "implementar")
  * Acronyms with locale-specific expansions

Store glossaries in the repo as `docs/l10n/glossary.csv` or in the translation platform.

---

## 9. Related Documents

| Document | Purpose |
|----------|---------|
| [Accessibility](./10-ACCESSIBILITY.md) | WCAG 2.2 AA compliance |
| [Style Guide](./11-STYLE_GUIDE.md) | Terminology consistency |
| [Visuals](./14-VISUALS.md) | Diagram localization |

---

**Previous:** [08 - Language Specific](./08-LANGUAGE_SPECIFIC.md)
**Next:** [10 - Accessibility](./10-ACCESSIBILITY.md)
