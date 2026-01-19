---
title: Documentation Reviews
type: standard
status: approved
owner: technical-writing-team
classification: public
created: "2025-12-09"
last_updated: "2025-12-12"
version: "1.0.0"
---



> **Goal:** Ensure every document undergoes rigorous checks for accuracy, clarity, and consistency, formalized through **three distinct review types**.

## 1. The Three Review Types

Docs are code. Just as code needs unit tests and peer reviews, docs need:

### Type A: Technical Review (Accuracy)

* **Reviewer:** Subject Matter Expert (SME), Senior Engineer, or Code Owner.
* **Focus:**
  * Is the code sample correct and runnable?
  * Are the technical facts accurate?
  * Are edge cases covered?
  * Is the architecture accurately represented?
* **Label:** `doc-review-technical`

### Type B: Audience Review (Clarity)

* **Reviewer:** A new team member, a user of the API, or a "fresh pair of eyes" unfamiliar with the feature.
* **Focus:**
  * Does the "Getting Started" flow actually work for a beginner?
  * Are prerequisites clearly stated?
  * Is the "Why" (context) clear before the "How"?
  * Are there confusing jargon terms?
* **Label:** `doc-review-audience`

### Type C: Writing Review (Consistency)

* **Reviewer:** Technical Writer or "Style Guardian" (or automated via `vale`).
* **Focus:**
  * Grammar, spelling, and punctuation.
  * Adherence to [Style Guide](./11-STYLE_GUIDE.md).
  * Formatting and structure stability.
  * Voice and Tone.
* **Label:** `doc-review-writing`

## 2. Review Workflow

1. **Pull Request:** All doc changes happen via PR.
2. **Checklist:** The PR description MUST include the customized Docs checklist:

    ```markdown
    - [ ] **Technical Review**: @SME_Name check for accuracy.
    - [ ] **Audience Review**: @Newcomer_Name check for clarity.
    - [ ] **Writing Review**: @Writer_Name (or Vale check pass).
    ```

3. **Approval:** Merge requires approval from at least one Code Owner (Technical) and passing CI checks (Writing).

---

## 3. Related Documents

| Document | Purpose |
|----------|---------|
| [Style Guide](./11-STYLE_GUIDE.md) | What to check in writing reviews |
| [Quality](./05-QUALITY.md) | Quality gates |
| [Governance](./07-GOVERNANCE.md) | Approval matrix |

---

**Previous:** [11 - Style Guide](./11-STYLE_GUIDE.md)
**Next:** [13 - Feedback](./13-FEEDBACK.md)
