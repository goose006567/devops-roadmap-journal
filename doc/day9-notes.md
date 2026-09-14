# Day 9 Notes — MLOps-Lite

## What I'd Monitor Differently for ml-api vs hello-api

Day 7's stack already covers CPU, memory, request rate, and error codes — the same infra metrics apply to any container. For ml-api, three things go beyond that:

1. **Prediction latency** — the model call is the expensive, non-deterministic part of the request. Time the `/predict` route separately from the dispatch: `histogram` of inference duration in ms (and ideally a breakdown per stage: preprocessing → model.predict → postprocessing). hello-api only needed "how long did the whole request take"; ml-api needs "how slow is the model itself, independent of FastAPI overhead".

2. **Distribution of predicted classes over time** — a `counter` for each predicted class (e.g. `iris_prediction_class_total{class="2"}`). If the class mix drifts (suddenly everything predicts class 2) or the input features' histogram shifts, that's **drift before the accuracy loss shows up in logs**. hello-api's correctness is black-and-white (HTTP 200 vs 500); ml-api's can silently rot.

3. **Model version currently loaded** — expose the artifact's version/checksum (e.g. `ml_model_version_info{tag="v1",sha="abc123"} = 1`). A drift alert is only actionable if you can say *which model* served those predictions. hello-api answers "which commit is live?" through normal image tags; ml-api needs it surfaced as a metric so alerts and dashboards correlate prediction quality to model version.

### One line of "why"
Both apps share the Day 7 infra monitoring; the delta is that ml-api needs to watch **what the model outputs** and **how it performs** over time — a model can be running fine and still be wrong.

## Deployment gotchas I hit on Day 9 (worth keeping)
- minikube's runtime is **containerd**, not Docker — `eval $(minikube docker-env)` + `docker build` fails (buildkit 404). Fix: `docker build` in the normal daemon, then `minikube image load <tag>`.
- The failed docker-env experiment crashed etcd → whole cluster needed `minikube stop/start`. Deployments survived and resynced automatically (declared state).
- `imagePullPolicy: Never` + containerd: image must be loaded into minikube before the Deployment starts, or pods stay ImagePullBackOff.