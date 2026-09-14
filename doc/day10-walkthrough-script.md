# Day 10 — Walkthrough Video Script

> Target: 3–5 min. Recording: QuickTime → File → New Screen Recording (mic on).
> Keep this file open on a second monitor / window while you narrate.

## Before you hit record (do these first!)
So the video is pure talking, not fumbling:
1. `git pull` on main so everything matches origin
2. Browser tabs open (logged in):
   - GitHub repo → Actions tab
   - GitHub repo → README (architecture diagram)
3. Terminal tabs open:
   - Tab A: repo root
   - Tab B: `kubectl get pods -w` (live watch)
   - Tab C: `kubectl port-forward svc/monitoring-grafana 3000:80`
   - Tab D: Grafana at `localhost:3000` → dashboard **Kubernetes / Compute Resources / Pod** (filter `hello-api`)
4. Test that `kubectl get pods` is responsive (no flaky cluster).

## Storyboard (0:00–0:45 = intro, 0:45–3:30 = walkthrough, 3:30–4:30 = oneliner close)

| Time | Screen shows | You say (interview mode) |
|---|---|---|
| 0:00–0:20 | README / architecture diagram | "This is a DevOps capstone I built across 10 days. The idea: one change should flow from a git push, through an automated security-gated pipeline, into a running Kubernetes deployment — with the health of the whole thing visible in a dashboard. Here's the system at a glance: ..." |
| 0:20–0:45 | Point at diagram | "On the left, a developer pushes to `main`. GitHub Actions tests, scans for critical vulnerabilities with Trivy, and only then builds and pushes the image. On the right, that image lands on Kubernetes — hello-api and a small ML model service — and everything reports into Prometheus/Grafana. Terraform is what would stand up the cloud side (I ran it against LocalStack so it costs nothing)." |
| 0:45–1:30 | Terminal Tab A: `echo 'version':'v3' >> ...` then git add/commit/push on a branch, open PR | "Now I'll make a real change — adding a version field to the API response. Small change, but it's the whole point: watch what happens when I merge it into main." |
| 1:30–2:30 | GH Actions tab → watch the run turn green | "There it is — the merge triggered CI automatically. Jobs ran in order: tests passed, Trivy scanned the image and found no critical vulnerabilities, and the image built and pushed to Docker Hub. Because the scan is a *gate*, a failing scan would have stopped the push right here." |
| 2:30–3:10 | Tab B live `kubectl get pods -w` → `kubectl rollout status`, then `kubectl exec` + curl showing `v3` | "Meanwhile the Deployment picked up the new image. Watch the rollout: old pod terminating, new one coming up — that's the rolling update, zero downtime. And here's the proof — the running pods now answer with `version: v3`." |
| 3:10–3:50 | Grafana dashboard (Tab D), highlight the 3 hello-api pods | "Now the observability side. This dashboard is driven by Prometheus scraping the cluster. You can see the three hello-api pods I just rolled — their CPU and memory are the same data that would trigger an alert if, say, error rate spiked above 5%. I'm monitoring *symptoms*, not just numbers." |
| 3:50–4:30 | Cut back to diagram | "The one-liner: I take containerized apps through a gated CI/CD pipeline into Kubernetes, and I can watch the whole thing from a dashboard. Drift and model versioning are the MLOps questions on top, which is what Day 9 explored. Scaffolding like this is what makes on-call and production changes boring — in a good way." |

## Notes for a strong delivery
- Keep sentences short; it's a *data* story, no buzzwords.
- If a command errors live, say: "let me show you what this failure looks like" — debugging on camera looks like confidence, not incompetence.
- Mute Slack/notifications before recording.
- Pause 1s on each new screen before speaking, so the editor can cut cleanly.