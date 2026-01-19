---
title: "Example: Incident Postmortem"
type: "example"
status: "approved"
classification: "internal"
owner: "@sre-team"
created: "2025-12-15"
last_updated: "2025-12-15"
version: "1.0.0"
context: "postmortem"
incident_id: "INC-2025-12-10-001"
severity: "high"
---

# Postmortem: Database Connection Pool Exhaustion

**Incident ID:** INC-2025-12-10-001
**Date:** 2025-12-10
**Duration:** 2 hours 15 minutes
**Severity:** High
**Status:** Resolved

---

## Executive Summary

On December 10, 2025, the TaskFlow API experienced a 2-hour 15-minute outage due to database connection pool exhaustion. The incident affected 100% of API requests, preventing users from accessing the service. Root cause was a connection leak in the background worker service that wasn't properly closing database connections.

**Impact:**

- Follows blameless culture principles
