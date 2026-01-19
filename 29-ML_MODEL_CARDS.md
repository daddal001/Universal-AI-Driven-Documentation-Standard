---
title: "ML Model Cards"
type: "standard"
status: "approved"
owner: "@ml-team"
classification: "public"
created: "2025-12-10"
last_updated: "2025-12-10"
version: "1.0.0"
---

# ML Model Cards

> **Goal:** Document machine learning models transparently using Model Cards (Google standard) to enable informed use, ensure EU AI Act compliance, and communicate limitations.

---

## 1. Model Card Template

### Required Sections

Every ML model MUST have a `MODEL_CARD.md`:

```markdown
# Model Card: [Model Name]

## Model Details

| Property | Value |
|----------|-------|
| **Model Name** | product-recommendation-v3 |
| **Version** | 3.2.1 |
| **Type** | Collaborative Filtering + Neural Network |
| **Framework** | PyTorch 2.1 |
| **License** | Proprietary |
| **Owner** | @ml-team |
| **Last Updated** | 2025-12-01 |

### Model Description

Brief description of what the model does:

> Predicts product recommendations based on user browsing history
> and purchase patterns. Uses a two-tower architecture with
> collaborative filtering for candidate generation and a neural
> network for ranking.

---

## Intended Use

### Primary Use Cases

- Product recommendations on homepage
- "You might also like" on product pages
- Personalized email recommendations

### Out-of-Scope Uses

❌ **Not intended for:**
- Credit decisions
- Employment screening
- Medical recommendations
- Any high-stakes automated decisions

### Users

- Product team (integration)
- Data science team (monitoring)
- End users (indirectly, via recommendations)

---

## Training Data

### Dataset Information

| Property | Value |
|----------|-------|
| **Source** | Internal user interaction logs |
| **Date Range** | Jan 2023 - Nov 2025 |
| **Size** | 50M interactions, 2M users, 100K products |
| **Geographic Coverage** | US, UK, DE, FR |

### Data Processing

- Removed users with < 5 interactions
- Excluded bot traffic (>100 actions/minute)
- Anonymized user IDs
- Removed PII before training

### Known Biases in Data

| Bias | Mitigation |
|------|------------|
| US users overrepresented (70%) | Stratified sampling |
| Power users dominate interactions | Capped at 1000 interactions/user |
| Seasonal trends | Rolling 6-month window |

---

## Evaluation

### Metrics

| Metric | Value | Threshold |
|--------|-------|-----------|
| **Hit Rate @10** | 0.42 | > 0.35 |
| **NDCG @10** | 0.38 | > 0.30 |
| **Coverage** | 85% | > 80% |
| **Novelty** | 0.72 | > 0.60 |

### Performance by Demographic

| Segment | Hit Rate @10 | Notes |
|---------|--------------|-------|
| New users (< 30 days) | 0.28 | Cold start problem |
| Active users | 0.48 | Best performance |
| US users | 0.44 | Slightly higher |
| EU users | 0.39 | Acceptable |

### Fairness Evaluation

| Protected Attribute | Metric | Acceptable Range |
|---------------------|--------|------------------|
| Gender (inferred) | Equal opportunity | ±5% |
| Age group | Demographic parity | ±10% |
| Geography | Equal accuracy | ±5% |

---

## Limitations

### Known Limitations

1. **Cold Start Problem** — New users with < 5 interactions
   receive generic recommendations
2. **Long-tail Products** — Products with < 100 interactions
   rarely surface
3. **Trending Sensitivity** — 24-48h delay in capturing trends
4. **Language** — Only trained on English product metadata

### Failure Modes

| Scenario | Expected Behavior |
|----------|-------------------|
| No user history | Return popular items |
| API timeout | Return cached recommendations |
| Model unavailable | Fallback to rule-based |

---

## Ethical Considerations

### Potential Harms

- May reinforce existing purchasing patterns (filter bubbles)
- Could promote higher-margin products if business metrics weighted

### Mitigations

- Diversity requirements in ranking (20% exploration)
- Regular fairness audits (quarterly)
- A/B testing for unintended effects

---

## Deployment

### Infrastructure

| Component | Details |
|-----------|---------|
| **Serving** | TensorFlow Serving on Kubernetes |
| **Latency (p99)** | < 50ms |
| **Throughput** | 10K requests/sec |
| **Update Frequency** | Daily retraining |

### Monitoring

- Model drift detection (daily)
- Prediction distribution monitoring
- A/B test dashboards

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.2.1 | Dec 2025 | Added diversity requirements |
| 3.2.0 | Nov 2025 | Improved cold-start handling |
| 3.0.0 | Sep 2025 | New two-tower architecture |
```

---

## 2. EU AI Act Compliance

### Risk Classification

| Risk Level | Examples | Requirements |
|------------|----------|--------------|
| **Unacceptable** | Social scoring | Prohibited |
| **High-Risk** | Credit, employment, medical | Full documentation, audit |
| **Limited Risk** | Chatbots, emotion detection | Transparency |
| **Minimal Risk** | Recommendations, spam filters | Voluntary |

### High-Risk AI Documentation

For high-risk systems, also document:

```markdown
## EU AI Act Compliance

### Risk Assessment

- **Risk Category:** High-Risk (if applicable)
- **Conformity Assessment:** [Date]
- **CE Marking:** [If applicable]

### Technical Documentation

- [ ] Description of intended purpose
- [ ] Description of system architecture
- [ ] Training, validation, testing data documentation
- [ ] Human oversight measures
- [ ] Accuracy, robustness, cybersecurity measures

### Transparency Obligations

Users are informed that:
- They are interacting with an AI system
- The AI is making recommendations, not decisions
- How to opt out of personalization
```

---

## 3. Model Registry Documentation

### Required Metadata

```yaml
# models/product-recommendation/metadata.yaml
name: product-recommendation
version: 3.2.1
status: production
owner: ml-team@example.com

artifacts:
  model: s3://models/product-rec/v3.2.1/model.pt
  config: s3://models/product-rec/v3.2.1/config.yaml
  model_card: ./MODEL_CARD.md

training:
  dataset: product-interactions-2023-2025
  framework: pytorch
  started: 2025-11-28T10:00:00Z
  completed: 2025-11-29T06:00:00Z

metrics:
  hit_rate_at_10: 0.42
  ndcg_at_10: 0.38
  coverage: 0.85

deployment:
  endpoint: https://ml.example.com/recommend
  replicas: 10
  resources:
    cpu: 4
    memory: 16Gi
    gpu: 1
```

---

## 4. Related Documents

| Document | Purpose |
|----------|---------|
| [Data Pipelines](./23-DATA_PIPELINES.md) | Training data pipelines |
| [Security & Compliance](./24-SECURITY_COMPLIANCE.md) | Data privacy |
| [API Documentation](./18-API_DOCUMENTATION.md) | Model serving APIs |

---

**Previous:** [28 - Mobile Apps](./28-MOBILE_APPS.md)
**Next:** [30 - Testing](./30-TESTING.md)
