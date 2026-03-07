---
title: "ADR-[NUMBER]: [TITLE]"
type: "adr"
status: "[proposed | accepted | deprecated | superseded | implemented]"
owner: "@architecture-team"
classification: "internal"
created: "[YYYY-MM-DD]"
last_updated: "[YYYY-MM-DD]"
version: "1.0.0"
decision_date: "[YYYY-MM-DD]"
decision_makers:
  - "@username1"
  - "@username2"
review_date: "[YYYY-MM-DD]"         # 6-12 months from decision_date
# Decision linking — add these when applicable:
# supersedes: "NNNN"                # ADR number this replaces
# superseded_by: "NNNN"            # ADR number that replaced this (added later)
# related_to:                       # Related ADR numbers
#   - "NNNN"
#   - "NNNN"
---

# ADR-[NUMBER]: [TITLE]

This decision record documents the choice of [technology/approach] for [component/system]. It affects engineers working on [affected areas] and should be reviewed on [review_date] or when assumptions change.

**Status:** [proposed | accepted | deprecated | superseded | implemented]
**Date:** [YYYY-MM-DD]
**Decision Makers:** [@username1, @username2]

---

## Context

[Describe the issue motivating this decision. What is the problem we're solving? Include business requirements, technical constraints, and forces at play. Use value-neutral language.]

## Decision Drivers

- [Driver 1: e.g., performance requirements]
- [Driver 2: e.g., team expertise]
- [Driver 3: e.g., cost constraints]
- [Driver 4: e.g., compliance requirements]

## Considered Options

### Option 1: [Name]

- **Pros:** [List advantages]
- **Cons:** [List disadvantages]
- **Estimated Effort:** [Low/Medium/High]

### Option 2: [Name]

- **Pros:** [List advantages]
- **Cons:** [List disadvantages]
- **Estimated Effort:** [Low/Medium/High]

### Option 3: [Name]

- **Pros:** [List advantages]
- **Cons:** [List disadvantages]
- **Estimated Effort:** [Low/Medium/High]

## Decision

[State the decision and rationale. Why was this option chosen over the alternatives? Use active voice: "We will..."]

## Consequences

### Positive

- [Positive consequence 1]
- [Positive consequence 2]

### Negative

- [Negative consequence 1]
- [Mitigation strategy]

### Risks

- [Risk 1 and mitigation]
- [Risk 2 and mitigation]

---

## Assumptions

<!-- RECOMMENDED for all ADRs. REQUIRED for P0/P1 decisions. -->
<!-- "What could cause problems if untrue now or later?" -->

| # | Assumption | Impact if Wrong | Monitoring |
|---|-----------|-----------------|------------|
| 1 | [Assumption 1] | [What breaks] | [How we detect it] |
| 2 | [Assumption 2] | [What breaks] | [How we detect it] |

---

## Confirmation

<!-- RECOMMENDED for all ADRs. REQUIRED for P0/P1 decisions. -->
<!-- "How will we verify this decision is working?" -->

Compliance with this ADR is confirmed by:

- [ ] [Design review / architecture review approved]
- [ ] [Implementation matches the decided pattern]
- [ ] [Automated test or metric threshold that validates the decision]

---

## Compliance Mapping

<!-- RECOMMENDED when the decision implements security or compliance controls. -->
<!-- Delete this section if not applicable. -->

| Framework | Control | How This ADR Addresses It |
|-----------|---------|--------------------------|
| [ISO 27001] | [A.X.Y — Control name] | [How this decision satisfies the control] |
| [SOC 2] | [CCX.Y — Control name] | [How this decision satisfies the control] |

---

## References

**REQUIRED:** List all external sources that informed this decision (minimum 2-3):

| # | Source | Type | URL |
|---|--------|------|-----|
| 1 | [Technology Official Documentation] | Vendor Docs | [https://...] |
| 2 | [Research Paper / Blog Post] | Research | [https://...] |
| 3 | [Benchmark / Case Study] | Benchmark | [https://...] |

*Source types: Standard, Best Practice, Benchmark, Vendor Docs, Research, Internal*

## Related Documents

- [Link to related ADRs]
- [Link to implementation PRs]
- [Link to runbooks or deployment guides]
