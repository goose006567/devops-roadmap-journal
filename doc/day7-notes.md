# Day 7 Notes — Monitoring & Observability

## What I Installed
- **kube-prometheus-stack** via Helm (`helm install monitoring prometheus-community/kube-prometheus-stack`)
- Install landed in the `default` namespace (not `monitoring` — Helm used the current context namespace)
- Stack = Prometheus (operator-managed StatefulSet) + Alertmanager + Grafana + kube-state-metrics + node-exporter
- Verifiers:
  - `kubectl get pods -l "release=monitoring"` → all `Running`
  - `kubectl port-forward svc/monitoring-grafana 3000:80` → Grafana at `localhost:3000`
  - Grafana admin password from secret `monitoring-grafana`

## Load Test on hello-api
- hello-api (from Day 4) → Service `hello-api-service` → 5 replica pods
- NodePort was unreachable from the macOS host (Docker-driver networking quirk) → used `kubectl port-forward svc/hello-api-service 8081:80`
- Fired **2000 requests** over ~30 seconds against it

## What I Observed (Kubernetes / Compute Resources / Pod dashboard)
- **CPU**: visible spike during the load window — moved on the graph, slightly lagged and stepped
- **Memory**: stayed flat — expected, hello-api is small
- The lag/stepped shape = Prometheus **scrape interval** (~30s), not lost data

## The Path from Curl to Graph (why it took a few seconds)
1. `curl` hits the Service (port-forwards to 8000)
2. Service routes to a Pod
3. Container runs the Python/uvicorn app
4. kubelet's **cAdvisor** counts CPU/memory seconds per container
5. **Prometheus** scrapes kubelet on its interval
6. **Grafana** queries Prometheus and plots

## One Alert I'd Set Up — and the "why" behind it
Alert: **CPU usage > 80% sustained for 5 minutes** (kube-prometheus-stack ships `KubeCPUOvercommit` / node CPU rules — tune to your app).

Better alert per Day-7 theory: alert on **symptoms users feel**, not raw resource numbers.
- Symptom alert example: **HTTP 5xx error rate > 5% for 5 minutes** — this is what users experience
- Resource alert like CPU > 80% only matters when it causes a symptom (errors/latency)

hello-api doesn't expose `/metrics` yet, so today we monitored it at the *container* level (infra). App-level metrics (requests, error rates, latency) need instrumentation — next step.

## Gotchas of the Day
1. quay.io image pulls took ~13 minutes of *waiting* before downloading — external registry slowness, not a config bug
2. Helm charts install into your current-context namespace unless you pass `-n`
3. `kubectl port-forward` blocks the terminal — run it in a separate tab