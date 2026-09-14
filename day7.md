# Day 7 Notes

## The Three Pillars of Observability
- **Metrics**: numbers over time — CPU%, request count, error rate. Good for trends & alerts
- **Logs**: discrete event records — "what happened at this moment, with these details"
- **Traces**: the path a single request takes through services, with timing per hop

Each pillar answers a different question. Real incidents usually need 2+ of them together.

## Prometheus's Model
Prometheus **pulls** metrics: it scrapes an HTTP endpoint (`/metrics`) on a schedule. Apps don't push data to it — they expose it, and Prometheus comes and gets it.

## Grafana
Grafana **visualizes** what Prometheus already collected. It doesn't collect data itself — it's a front-end over data sources.

## Alerting Principle
Alert on **symptoms users feel** (high error rate, high latency), not raw resource numbers. A CPU spike that doesn't affect users is interesting, not page-worthy.

## Extra Notes (day-of)
- Prometheus + Grafana together = the classic open-source stack (`kube-prometheus-stack` on k8s)
- Instrument your app (expose /metrics) vs. scrape infrastructure (node exporter) are two different collection layers