---
title: "Secrets Management Documentation"
type: "guide"
status: "approved"
classification: "internal"
owner: "@security-team"
created: "2025-12-14"
last_updated: "2025-12-14"
version: "1.0.0"
---

# Secrets Management

> **Purpose:** Guidelines for secure storage, access, and rotation of secrets across all services.

## Quick Reference

| Secret Type | Storage | Rotation | Access |
|-------------|---------|----------|--------|
| API Keys | Vault | 90 days | Service accounts |
| Database credentials | Vault | 30 days | Automated |
| TLS certificates | Cert Manager | 60 days | Automated |
| OAuth tokens | Vault | On expiry | Service accounts |

---

## 1. Secret Storage

### Where to Store Secrets

| ✅ Use | ❌ Never Use |
|--------|-------------|
| HashiCorp Vault | Git repositories |
| AWS Secrets Manager | Environment variables in code |
| Kubernetes Secrets (encrypted) | Configuration files |
| GitHub Actions Secrets | Slack messages |

### Vault Configuration

```hcl
# Example: Creating a secret in Vault
vault kv put secret/production/database \
  username="app_user" \
  password="$(openssl rand -base64 32)"
```

---

## 2. Accessing Secrets

### In Kubernetes

```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: app
      env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: database-credentials
              key: password
```

### In Application Code

```python
# ✅ Good: Read from environment
import os
db_password = os.environ.get("DB_PASSWORD")

# ❌ Bad: Hardcoded
db_password = "supersecret123"  # NEVER DO THIS
```

### In CI/CD

```yaml
# GitHub Actions
jobs:
  deploy:
    steps:
      - name: Deploy
        env:
          API_KEY: ${{ secrets.API_KEY }}
        run: ./deploy.sh
```

---

## 3. Secret Rotation

### Automated Rotation Schedule

| Secret Type | Frequency | Method |
|-------------|-----------|--------|
| Database passwords | 30 days | Vault dynamic credentials |
| API keys | 90 days | Key rotation script |
| TLS certs | 60 days | cert-manager |
| Service tokens | On expiry | OAuth refresh |

### Manual Rotation Process

1. Generate new secret in Vault
2. Update application to use new secret
3. Verify application works with new secret
4. Revoke old secret
5. Document rotation in audit log

---

## 4. Emergency Procedures

### Secret Compromise

If a secret is exposed:

1. **Immediately revoke** the compromised secret
2. **Generate new secret** via Vault
3. **Deploy** updated secret to all services
4. **Audit** access logs for unauthorized use
5. **Report** to security team within 1 hour

```bash
# Emergency: Revoke compromised API key
vault lease revoke -prefix secret/compromised-service/
```

---

## 5. Audit & Compliance

### Logging Requirements

All secret access must be logged:

```json
{
  "timestamp": "2025-12-14T10:30:00Z",
  "action": "secret_access",
  "secret_path": "secret/production/database",
  "accessor": "service-account-payment",
  "source_ip": "10.0.1.50",
  "success": true
}
```

### Compliance Checklist

- [ ] All secrets encrypted at rest (AES-256)
- [ ] All secrets encrypted in transit (TLS 1.3)
- [ ] Access logged to SIEM
- [ ] Rotation schedule documented
- [ ] Break-glass procedure tested quarterly

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [Security & Compliance](./24-SECURITY_COMPLIANCE.md) | Overall security standards |
| [CI/CD Pipelines](./22-CICD_PIPELINES.md) | Secret injection in pipelines |
| [Infrastructure Code](./25-INFRASTRUCTURE_CODE.md) | IaC secret management |
