---
title: "Compliance Control Matrix"
type: "reference"
status: "draft"
classification: "confidential"
owner: "@compliance-team"
created: "2025-12-15"
last_updated: "2025-12-15"
version: "1.0.0"
compliance:
  - "GDPR"
  - "SOC2"
  - "ISO27001"
---

# Compliance Control Matrix

**Organization:** [Company Name]
**Last Reviewed:** YYYY-MM-DD
**Next Review:** YYYY-MM-DD
**Owner:** @compliance-team

---

## Overview

This document maps compliance controls to their implementation and documentation evidence.

---

## GDPR Controls

| Control ID | Requirement | Implementation | Documentation | Last Reviewed |
|------------|-------------|----------------|--------------|---------------|
| **Art. 30** | Data Processing Record | [Data Processing Record](./DATA_PROCESSING_RECORD.md) | Article 30 record | YYYY-MM-DD |
| **Art. 32** | Security of Processing | [Security Architecture](./SECURITY_ARCHITECTURE.md) | Technical measures | YYYY-MM-DD |
| **Art. 33** | Breach Notification | [Breach Notification Procedure](./BREACH_NOTIFICATION.md) | 72-hour procedure | YYYY-MM-DD |
| **Art. 35** | Data Protection Impact Assessment | [DPIA](./DPIA.md) | Impact assessment | YYYY-MM-DD |

---

## SOC2 Controls

| Control ID | Control Description | Implementation | Documentation Evidence | Status |
|------------|---------------------|----------------|------------------------|--------|
| **CC6.1** | Logical Access Controls | RBAC, MFA | [Access Control Policy](./ACCESS_CONTROL.md) | ✅ Compliant |
| **CC7.2** | System Monitoring | 24/7 monitoring, alerts | [Monitoring Runbook](./MONITORING.md) | ✅ Compliant |
| **CC8.1** | Change Management | Change approval process | [Change Management Policy](./CHANGE_MANAGEMENT.md) | ✅ Compliant |

---

## ISO27001 Controls

| Control ID | Control Name | Implementation | Documentation | Status |
|------------|--------------|----------------|---------------|--------|
| **A.9.2.1** | User Registration | User onboarding process | [User Onboarding](./USER_ONBOARDING.md) | ✅ Compliant |
| **A.12.4.1** | Event Logging | Centralized logging | [Logging Standards](./LOGGING.md) | ✅ Compliant |
| **A.18.1.1** | Legal Requirements | Compliance documentation | [Legal Compliance](./LEGAL_COMPLIANCE.md) | ✅ Compliant |

---

## Audit Trail

| Date | Action | Performed By | Details |
|------|--------|--------------|---------|
| YYYY-MM-DD | Control review | @compliance-team | Quarterly review completed |

---

**Note:** Customize with your organization's compliance requirements and control mappings.
