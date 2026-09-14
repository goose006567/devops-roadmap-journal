# Day 9 Notes — MLOps-Lite

## What Actually Differs from Normal App Deployment

1. **Model versioning** — what matters in production is *which trained artifact* is live, not just which code commit. Two images can run identical code (same `predict()` wrapper) yet serve different predictions because the `model.pkl` baked inside changed. Model registry (MLflow, or even an S3 bucket with versioned keys) tracks this.

2. **Drift** — accuracy can silently degrade **with zero code changes**. Real-world data shifts (seasonality, new user behavior, a changed upstream feed), and the model keeps confidently predicting on inputs it was never trained to handle. You also see **concept drift** (the relationship the model learned changed) vs **data drift** (input distribution moved). No crash, no error log — just quietly worse answers.

3. **Resources** — inference ranges from trivial (a tiny classifier on one CPU core) to GPU-needing (LLMs). That changes scheduling (GPU nodes/taints in k8s), autoscaling (GPU-backed HPA on custom metrics), and cost structure vs the CPU-only world of hello-api.

## The Serving Pattern (the "same" part)

Wrap the model in a REST API — the API layer is *indifferent* to whether its backend is a database query or `model.predict()`. This is why everything from Day 3 onward transfers directly:
- model → **Docker image** (same multi-stage build; bake in the serialized artifact)
- FastAPI route → `POST /predict` instead of `GET /`
- k8s Deployment/Service, CI build+push+gate, Trivy scans, non-root user — **identical**
- Difference in packaging: model files are often large (GBs), so you keep the artifact *separate* from code (CI artifact / S3) rather than a 2GB Docker layer + a heavier image for every retrain.

## What You'd Monitor Differently (vs Day 7)

Day 7: CPU, memory, request rate, latency of the *system*.
Day 9 adds:
- **Prediction latency** (model inference time as its own metric, not lumped into request duration)
- **Input/output distributions** — histogram of feature values and predicted classes over time; if the input histogram shifts or the output mix changes, that's drift, and it can alert *before* quality tanks.

Same stack works: Prometheus/Grafana. New: a metric per stage (preprocessing / inference / postprocessing), NaN/edge-case counters, and a shadow retrain trigger (e.g. "model retrained when accuracy on rolling window drops below X").

## TL;DR
Deploying the model = Day 3–8. The hard part is **governing the artifact** and **noticing when it rots** — that's the MLOps delta.