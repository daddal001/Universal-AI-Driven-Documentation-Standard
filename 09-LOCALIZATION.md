---
title: "Localization Standard"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-09"
last_updated: "2025-01-12"
version: "1.1.0"
---



> **Goal:** Ensure documentation is "World Ready" by design, supporting global audiences through robust internationalization (i18n) and localization (l10n) strategies.

## 1. i18n Readiness Principles

Before translation typically begins, documentation must be *internationalized*.

* **Code Separation:** Never hardcode text inside diagrams or screenshots. Use SVGs with editable text layers or keep text in captions.
* **Expansion Room:** Design layouts (tables, callouts) to accommodate 30% text expansion (common when translating English to German/Spanish).
* **Date/Time Formats:** Use ISO 8601 (`YYYY-MM-DD`) strictly. Avoid "01/02/2024" (ambiguous).
* **Cultural Neutrality:** Avoid idioms ("hit it out of the park"), sports metaphors, or region-specific references.

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
└── ja/ (Japanese)
    ├── getting-started.md
    └── images/
```

> **Note:** The `en/` folder is the **canonical source**. Changes are made there first, then propagated to other directories.

## 3. Translation Workflow

1. **Freeze:** The English version must be "Stable" or "Approved" before translation begins.
2. **Context:** Provide a "Translation Kit" if working with external vendors:
    * **Glossary of Terms (e.g., "Do not translate 'Pod', 'Service'").**
    * **Descriptions of UI elements (e.g., "Button label", "Error message").**
3. **Validation:** Localized docs must pass the same linting/structure checks as English docs.

## 4. Automation

* **Sync Checks:** CI should flag if `es/doc.md` is significantly older (~5 commits behind) than `en/doc.md`.
* **Asset Checks:** Verify that all images present in `en/` exist in `es/` (or fallback to `en/`).

---

## 5. Related Documents

| Document | Purpose |
|----------|---------|
| [Accessibility](./10-ACCESSIBILITY.md) | WCAG 2.2 AA compliance |
| [Style Guide](./11-STYLE_GUIDE.md) | Terminology consistency |

---

**Previous:** [08 - Language Specific](./08-LANGUAGE_SPECIFIC.md)
**Next:** [10 - Accessibility](./10-ACCESSIBILITY.md)
