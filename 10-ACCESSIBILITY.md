---
title: "Accessibility Standard"
type: "standard"
status: "approved"
owner: "@documentation-maintainer"
classification: "public"
created: "2025-12-09"
last_updated: "2026-03-07"
version: "1.2.0"
---

# Accessibility Standard

> **Goal:** Ensure all documentation is accessible to users with disabilities, targeting **WCAG 2.2 Level AA** compliance.

---

## 1. Perceivable

### 1.1 Text Alternatives (Alt Text)

* **Rule:** Every image must have an `alt` attribute.
* **Bad:** `alt="Screenshot"`
* **Good:** `alt="Screenshot of the 'Settings' menu showing the 'Dark Mode' toggle in the 'On' position."`
* **Decorative:** Use `alt=""` for purely decorative images.
* **Complex diagrams:** Provide a text description below the image or link to a detailed description.

### 1.2 Contrast

* **Rule:** Text must have a contrast ratio of at least **4.5:1** against the background.
* **Large Text:** (18pt+ or 14pt bold) must have **3.1:1**.
* **Non-text elements:** UI components and graphical objects need **3:1** contrast (WCAG 2.2 1.4.11).

### 1.3 Adaptable Content

* Use **semantic Markdown/HTML**. Do not use bold text (`**Heading**`) to fake a header; use `# Heading`.
* Do not rely on color alone to convey meaning (e.g., "The red fields are required"). Use "The required fields (marked *)".
* Tables must have header rows (`| Header |`) — screen readers use them for navigation.

## 2. Operable

### 2.1 Keyboard Accessible

* All interactive elements (tabs, code copy buttons, search) must be usable via `Tab`, `Enter`, and `Space`.
* No "keyboard traps" (focus gets stuck in a component).
* Skip-to-content links on generated doc sites.

### 2.2 Navigable

* **Headings:** Must follow a logical hierarchy (`#` -> `##` -> `###`). Do not skip levels (e.g., `##` to `####`).
* **Link Purpose:** Link text must describe the destination.
  * **Bad:** "Click [here](...)."
  * **Good:** "See the [Installation Guide](...)."
* **Table of Contents:** Documents longer than 3 sections should include a TOC or be rendered by a site generator that auto-generates one.

### 2.3 Enough Time

* Auto-playing animations or videos must have pause/stop controls.
* Avoid content that flashes more than 3 times per second (seizure risk — WCAG 2.3.1).

## 3. Understandable

### 3.1 Readable

* Aim for a **Grade 10** reading level or lower (Flesch-Kincaid). Use short sentences.
* Define acronyms on first use: "Service Level Objective (SLO)".
* Use consistent terminology — don't alternate between "deploy" and "release" for the same concept.

### 3.2 Predictable

* Navigation menus and search bars should appear in the same place on every page.
* Interactive elements should behave consistently across pages.

### 3.3 Input Assistance

* For interactive documentation (API explorers, forms): provide clear error messages that identify the field and suggest correction.
* Required fields must be programmatically identified, not just visually marked.

## 4. Robust

* **Parsing:** Ensure HTML/Markdown is free of syntax errors (unclosed tags) that break screen readers.
* **Name, Role, Value:** Interactive widgets in generated doc sites must expose proper ARIA roles.
* **Status Messages:** Dynamic content updates (search results, form validation) must be announced to screen readers via ARIA live regions.

## 5. WCAG 2.2 Checklist for Documentation

| Criterion | Level | Check | How to Verify |
|-----------|-------|-------|---------------|
| 1.1.1 Non-text Content | A | All images have alt text | `markdownlint` MD045 |
| 1.3.1 Info and Relationships | A | Semantic headings, not bold-as-heading | `markdownlint` MD036 |
| 1.4.3 Contrast (Minimum) | AA | 4.5:1 text contrast | Browser DevTools, axe |
| 1.4.11 Non-text Contrast | AA | 3:1 for UI components | axe, manual check |
| 2.1.1 Keyboard | A | All interactive elements keyboard-operable | Manual tab-through |
| 2.4.1 Skip Navigation | A | Skip-to-content link on doc sites | Manual check |
| 2.4.2 Page Titled | A | Each page has a descriptive `<title>` | Automated scan |
| 2.4.6 Headings Descriptive | AA | Headings describe content | Editorial review |
| 2.4.7 Focus Visible | AA | Keyboard focus indicator visible | Manual tab-through |
| 3.1.1 Language of Page | A | `lang` attribute set on `<html>` | Automated scan |
| 4.1.2 Name, Role, Value | A | ARIA roles on interactive widgets | axe, Lighthouse |

## 6. Testing Tools

| Tool | Type | What It Checks |
|------|------|----------------|
| **axe-core** | Browser extension / CI | WCAG violations in rendered HTML |
| **Lighthouse** | Chrome DevTools / CI | Accessibility score + specific violations |
| **pa11y** | CLI / CI | WCAG 2.2 AA automated checks on URLs |
| **WAVE** | Browser extension | Visual overlay of accessibility issues |
| **NVDA** | Screen reader (Windows) | Real screen reader experience |
| **VoiceOver** | Screen reader (macOS/iOS) | Real screen reader experience |

### CI Integration (pa11y)

```yaml
- name: Accessibility check
  run: |
    npx pa11y-ci --config .pa11yci.json
```

Example `.pa11yci.json`:

```json
{
  "defaults": {
    "standard": "WCAG2AA",
    "timeout": 30000
  },
  "urls": [
    "http://localhost:8000/",
    "http://localhost:8000/getting-started/"
  ]
}
```

## 7. Screen Reader Testing Guide

Not everything can be caught by automated tools. Manual screen reader testing should cover:

1. **Page structure:** Navigate by headings (NVDA: `H` key). Confirm logical order.
2. **Images:** Confirm alt text is read and makes sense in context.
3. **Code blocks:** Verify code is announced as a code block, not read character-by-character.
4. **Tables:** Navigate by cells (NVDA: `Ctrl+Alt+Arrow`). Confirm headers are associated.
5. **Links:** List all links (NVDA: `Insert+F7`). Confirm link text is descriptive without surrounding context.

**Frequency:** Screen reader test at least once per major doc site redesign or template change.

## 8. Automated Enforcement

We use `markdownlint` and `pa11y` (for generated sites) to enforce these rules.

| Rule | What It Checks |
|------|----------------|
| `MD001` | Heading levels increment by one |
| `MD003` | Heading style consistency |
| `MD036` | No emphasis as heading |
| `MD045` | Images must have alt text |

---

## 9. Related Documents

| Document | Purpose |
|----------|---------|
| [Localization](./09-LOCALIZATION.md) | i18n for global accessibility |
| [Style Guide](./11-STYLE_GUIDE.md) | Language clarity |
| [Visuals](./14-VISUALS.md) | Diagram accessibility |

---

**Previous:** [09 - Localization](./09-LOCALIZATION.md)
**Next:** [11 - Style Guide](./11-STYLE_GUIDE.md)
