---
title: "Example: CVE Security Postmortem"
type: "example"
status: "approved"
classification: "internal"
owner: "@sre-team"
created: "2026-03-04"
last_updated: "2026-03-04"
version: "1.0.0"
context: "postmortem-cve"
cve_id: "CVE-2025-99999"
cvss_score: "7.5"
cvss_severity: "high"
---

# Incident: Image Registry Dependency Uses Vulnerable `libcurl` Version

Post-incident analysis for engineers, stakeholders, and future on-call responders. Our container base image shipped with `libcurl` 8.4.0 containing a header injection vulnerability (CVE-2025-99999). This affected all 7 backend services in `app` namespace on 2025-11-20. We document failures to prevent recurrence.

**Date:** 2025-11-20
**Duration:** 4 hours (discovery to patched images deployed)
**Severity:** P1
**Author:** @platform-team
**Status:** Complete
**Type:** Security-CVE

---

## Summary

> On November 20, 2025, a routine `trivy` scan flagged CVE-2025-99999 (CVSS 7.5 HIGH) in the `libcurl` library bundled with our `python:3.11-slim` base image. The vulnerability allows HTTP header injection via crafted redirect responses, potentially enabling request smuggling. All 7 backend services were affected. No exploitation occurred. Resolution involved rebuilding all service images on `python:3.11-slim-bookworm` (which includes `libcurl` 8.5.0) and redeploying via ArgoCD.

---

## Vulnerability Details

| Field | Value |
|-------|-------|
| **CVE ID** | CVE-2025-99999 |
| **CVSS Score** | 7.5 (High) |
| **CVSS Vector** | CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N |
| **EPSS Score** | 4.2% (as of 2025-11-20) |
| **CISA KEV** | No |
| **CWE** | CWE-113: Improper Neutralization of CRLF Sequences in HTTP Headers |
| **Affected Component** | libcurl < 8.5.0 (via python:3.11-slim base image) |
| **Fixed Version** | libcurl 8.5.0 (included in python:3.11-slim-bookworm) |
| **Our Version (Before)** | libcurl 8.4.0 (python:3.11-slim-bullseye) |
| **Our Version (After)** | libcurl 8.5.0 (python:3.11-slim-bookworm) |
| **MITRE ATT&CK** | Initial Access: T1190 — Exploit Public-Facing Application |
| **Patch Available Date** | 2025-11-15 |
| **Remediation Deadline** | 2025-12-20 (30-day High SLA) |
| **Remediation Completed** | 2025-11-20 |
| **SLA Met** | ✅ Yes (30 days under deadline) |

### Attack Vector Analysis

An attacker could exploit this by controlling a URL that our services follow via HTTP redirects (e.g., a webhook callback URL or AI model endpoint). The crafted redirect response could inject CRLF sequences into subsequent HTTP headers, potentially enabling:

1. **Request smuggling** through our nginx reverse proxy
2. **Cache poisoning** if CDN is in the path
3. **Session fixation** by injecting `Set-Cookie` headers

In our deployment, the risk is mitigated by: (a) gateway CORS whitelist limits outbound connections, (b) AI service connects only to Vertex AI endpoints, and (c) all inter-service communication is within the Kubernetes cluster network.

### GDPR Data Impact Assessment

| Question | Answer |
|----------|--------|
| Could personal data be accessed? | No |
| Data categories at risk | N/A (header injection, not data exfiltration) |
| Data subjects at risk | N/A |
| Breach notification required? | No |
| Supervisory authority notified? | N/A |

### Backlog Check

| Question | Answer |
|----------|--------|
| Was a Dependabot/Renovate PR open for this update? | No (base image, not pip dependency) |
| Was a security advisory previously triaged? | No (first seen via Trivy scan) |
| If yes, why was it deprioritized? | N/A |
| Process change to prevent future deprioritization | Added base image CVE scanning to weekly CI schedule |

### Recurrence Analysis

| Previous Incident | Similarity | Action Items Completed? |
|-------------------|------------|------------------------|
| _None_ | First base image CVE incident | N/A |

---

## Impact

| Metric | Value |
|--------|-------|
| Duration | 4 hours (discovery to deployment) |
| Users Affected | 0 (no exploitation detected) |
| Requests Failed | 0 |
| Revenue Impact | $0 |
| SLA Status | Met |

**Operational impact:** All 7 service images required rebuild and redeployment. No downtime — rolling deployment via ArgoCD.

---

## Timeline

| Time (UTC) | Event |
|------------|-------|
| 09:00 | Weekly Trivy scan flags CVE-2025-99999 (HIGH) in all 7 service images |
| 09:15 | Platform team triages: CVSS 7.5, affects libcurl in base image |
| 09:30 | Confirmed `python:3.11-slim-bookworm` includes patched libcurl 8.5.0 |
| 09:45 | Updated all Dockerfiles: `FROM python:3.11-slim` → `FROM python:3.11-slim-bookworm` |
| 10:00 | CI pipeline triggered — all 7 images building |
| 10:30 | Images built, signed with cosign, pushed to Artifact Registry |
| 11:00 | ArgoCD detected new digests, began rolling deployment |
| 12:00 | All 7 services deployed, health checks passing |
| 13:00 | Post-deployment Trivy scan confirms CVE-2025-99999 resolved |

---

## Root Cause Analysis

### What Happened

Our service Dockerfiles used `python:3.11-slim` (unqualified Debian release) which resolved to a `bullseye` variant containing `libcurl` 8.4.0. The `bookworm` variant had already shipped with the patched `libcurl` 8.5.0, but we were not pinning the Debian release.

### Contributing Factors

1. **Unpinned base image** — `python:3.11-slim` without Debian release qualifier meant the resolved image depended on Docker Hub's default
2. **No base image CVE alert** — Trivy only ran on PR changes, not on a schedule to catch upstream CVEs
3. **Transitive dependency** — `libcurl` is not a direct pip dependency; it comes from the OS layer

### Five Whys

1. **Why** were services running vulnerable `libcurl`? → Base image included libcurl 8.4.0
2. **Why** was the base image vulnerable? → We used `python:3.11-slim` without pinning the Debian release
3. **Why** didn't we pin the Debian release? → Original Dockerfiles used the generic tag for simplicity
4. **Why** wasn't the CVE caught earlier? → Trivy only ran on code changes, not on a schedule for base image drift
5. **Why** was there no scheduled scan? → Base image CVE scanning was not part of the CI/CD pipeline

---

## What Went Well

- Trivy correctly identified the CVE during its scan
- Fix was straightforward: base image swap, no code changes needed
- ArgoCD rolling deployment caused zero downtime
- Binary Authorization + cosign attestation ensured only signed images deployed

## Where We Got Lucky

- No known exploitation of CVE-2025-99999 in the wild before we patched
- The `bookworm` variant already included the fix — no need to wait for an upstream release
- All services use the same base image, so one Dockerfile change pattern applied everywhere

## What Could Be Improved

- **Scheduled scanning** — Should run Trivy weekly against deployed images, not just on code changes
- **Base image pinning** — Pin Debian release (e.g., `bookworm`) to make updates explicit
- **Automated base image updates** — Consider Renovate for Dockerfile base image PRs

---

## Action Items

| Action | Owner | Due Date | Status | Ticket |
|--------|-------|----------|--------|--------|
| Pin all Dockerfiles to `bookworm` release | @platform | 2025-11-20 | ✅ DONE | — |
| Add weekly Trivy scan workflow for deployed images | @platform | 2025-12-01 | ✅ DONE | — |
| Evaluate Renovate for Dockerfile base image PRs | @platform | 2025-12-15 | 🔲 TODO | — |
| Document base image update procedure in runbook | @sre | 2025-12-01 | 🔲 TODO | — |

---

## Lessons Learned

1. **Pin your base images to Debian release** — `python:3.11-slim` is ambiguous; `python:3.11-slim-bookworm` is explicit and auditable.
2. **Schedule CVE scans independent of code changes** — Upstream vulnerabilities appear on their own timeline, not yours.
3. **Transitive OS dependencies are invisible** — pip-audit catches Python CVEs, but OS-level libraries (libcurl, openssl) require container scanning.

---

## Compliance Evidence Checklist

| Requirement | Standard | Verified |
|-------------|----------|----------|
| Vulnerability identified and classified | ISO 27001 A.5.25 | ✅ |
| Response actions documented | ISO 27001 A.5.26 | ✅ |
| Root cause analyzed | ISO 27001 A.5.27 | ✅ |
| Evidence preserved (logs, screenshots) | ISO 27001 A.5.28 | ✅ |
| Remediation SLA tracked | SOC 2 CC7.4 | ✅ |
| GDPR data impact assessed | GDPR Art. 33-34 | ✅ |
| Action items have owners and due dates | SOC 2 CC7.5 | ✅ |
| Supply chain impact assessed | NIS2 Art. 23 | ✅ |

---

## Appendix

- [NVD Advisory](https://nvd.nist.gov/vuln/detail/CVE-2025-99999) _(fictional)_
- [libcurl Advisory](https://curl.se/docs/security.html) _(fictional)_
- [Trivy Scan Results](https://github.com/org/repo/actions/runs/XXX)
- [Deployment PR](https://github.com/org/repo/pull/XXX)

---

> **Note:** This is a fictional example demonstrating the CVE postmortem template format.
> See `docs/standards/27-POSTMORTEMS.md` §4 for field definitions and requirements.
