# End-to-End Architecture (Day 10 Capstone)

> Dev flow: code push → CI/CD → registry → Kubernetes → observability.

```mermaid
flowchart LR
    subgraph Dev["Developer (macOS)"]
        A[git push origin main]
    end

    subgraph CI["GitHub Actions (ci.yml)"]
        T[test job: pytest]
        B[build image]
        S[Trivy scan - gate]
        P[push image to Docker Hub]
    end

    subgraph Registry["Artifact Registry"]
        DH[(Docker Hub<br/>goose195/hello-api :latest<br/>iris model artifact (ml-api))]
    end

    subgraph IaC["Terraform - Infrastructure as Code"]
        TF[main.tf<br/>provider ~>4.0, LocalStack backend]
        S3[(S3 bucket)]
        EC2[EC2 instance]
    end

    subgraph Cluster["Kubernetes (minikube, containerd runtime)"]
        HAPI["deployment: hello-api<br/>3-5 replicas<br/>NodePort 30080"]
        MLAPI["deployment: ml-api (iris model)<br/>3 replicas<br/>NodePort 30081"]
        MON["kube-prometheus-stack<br/>(Prometheus + Alertmanager + Grafana)"]
    end

    subgraph Observe["Observability"]
        G[Grafana dashboard<br/>cluster/pod CPU & memory<br/>request-rate, latency]
        AL[Alerts: 5xx rate > 5%<br/>CPU > 80% sustained]
    end

    A --> CI
    T --> B
    B --> S
    S -- "CRITICAL=0 only" --> P
    P --> DH

    TF -- provisions ---> S3
    TF -- provisions ---> EC2

    DH -->|"kubectl apply pulls image"| HAPI
    HAPI -. "NodePort 30080" .-> MON
    MLAPI -. "NodePort 30081" .-> MON
    MON --> G
    MON --> AL

    style S fill:#7c3,stroke:#333,stroke-width:2px
    style DH fill:#fb4,stroke:#333,stroke-width:2px
    style Cluster fill:#eef,stroke:#333,stroke-width:2px
```

## Flow, in 4 sentences (the interview version)
1. **Code → CI**: every push to `main` triggers GitHub Actions — tests run (`pytest`), the image builds, and a **Trivy gate** blocks the pipeline if any CRITICAL vulnerability exists (nothing ships until it's clean).
2. **Registry**: a clean image is pushed to Docker Hub; for ml-api the model artifact (`model.joblib`) travels inside that image — the Deployable is code **plus** trained model.
3. **Infra**: Terraform declares what the cloud should look like (demonstrated against LocalStack for cost: S3 bucket + EC2 instance created, verified, destroyed). In real AWS it would be the same `main.tf` against live resources.
4. **Deploy + observe**: `kubectl apply` updates the Deployment; Kubernetes rolls it out; Prometheus scrapes the cluster and Grafana shows the new deployment's health (CPU, memory, request rate) with alerts on user-facing symptoms (5xx > 5%).

## The Drift/Dimension Day 9 adds
- Monitoring isn't just infra: log/query **prediction latency**, **predicted-class distributions** (drift), and the **loaded model version**.
- A model can be up and *wrong* — that's the one thing this pipeline's normal health checks won't catch.

## To redraw in Excalidraw / draw.io
Same boxes, same arrows. Useful tips for clarity:
- Keep the 5 swimlanes: **Dev → CI → Registry → Infra → Kubernetes+Observability**
- Draw the Trivy gate as a diamond (a decision point), not a box
- Use color only for the gate (green on pass) and the registry (amber "single source of truth")
- Add a dashed line from GitHub Actions to the cluster labeled "kubectl apply (from CI)" if you automate deploy-on-merge later
- Label each edge with the protocol/artifact it carries (HTTP, image bytes, metrics scrape)