---
title: "Accessibility Standard"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-09"
last_updated: "2025-01-12"
version: "1.1.0"
---



> **Goal:** Ensure all documentation is accessible to users with disabilities, targeting **WCAG 2.2 Level AA** compliance.

## 1. Perceivable

* **Text Alternatives (Alt Text):**
  * **Rule:** Every image must have an `alt` attribute.
  * **Bad:** `alt="Screenshot"`
  * **Good:** `alt="Screenshot of the 'Settings' menu showing the 'Dark Mode' toggle in the 'On' position."`
  * **Decorative:** Use `alt=""` for purely decorative images.
* **Contrast:**
  * **Rule:** Text must have a contrast ratio of at least **4.5:1** against the background.
  * **Large Text:** (18pt+) must have **3.1:1**.
* **Adaptable Content:**
  * Use **semantic Markdown/HTML**. Do not use bold text (`**Heading**`) to fake a header; use `# Heading`.
  * Do not rely on color alone to convey meaning (e.g., "The red fields are required"). Use "The required fields (marked *)".

## 2. Operable

* **Keyboard Accessible:**
  * All interactive elements (tabs, code copy buttons, search) must be usable via `Tab`, `Enter`, and `Space`.
  * No "keyboard traps" (focus gets stuck in a component).
* **Navigable:**
  * **Headings:** Must follow a logical hierarchy (`#` -> `##` -> `###`). Do not skip levels (e.g., `##` to `####`).
  * **Link Purpose:** Link text must describe the destination.
    * **Bad:** "Click [here](...)."
    * **Good:** "See the [Installation Guide](...)."

## 3. Understandable

* **Readable:** Aim for a **Grade 10** reading level or lower (Flesch-Kincaid). Use short sentences.
* **Predictable:** Navigation menus and search bars should appear in the same place on every page.

## 4. Robust

* **Parsing:** Ensure HTML/Markdown is free of syntax errors (unclosed tags) that break screen readers.

## 5. Automated Enforcement

We use `markdown-lint` and `pa11y` (for generated sites) to enforce these rules.

* **Check:** `MD001` (Heading levels)
* **Check:** `MD045` (Images must have alt text)

---

## 6. Related Documents

| Document | Purpose |
|----------|---------|
| [Localization](./09-LOCALIZATION.md) | i18n for global accessibility |
| [Style Guide](./11-STYLE_GUIDE.md) | Language clarity |
| [Visuals](./14-VISUALS.md) | Diagram accessibility |

---

**Previous:** [09 - Localization](./09-LOCALIZATION.md)
**Next:** [11 - Style Guide](./11-STYLE_GUIDE.md)
