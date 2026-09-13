# Day 4 Notes

## Core Kubernetes Concepts
- **Pod**: the smallest deployable unit - one or more containers that share networking/storage
- **Deployment**: manages ReplicaSets and provides self-healing (declared desired state, reconciles toward it)
- **Service**: a stable network endpoint / load balancer in front of a set of pods

## Deploying hello-api (Minikube)
- `k8s/deployment.yaml`: declares 3 replicas of the `hello-api` image
- `k8s/service.yaml`: a NodePort service exposing the app on port 30080
- Scaled 3 → 5 replicas with `kubectl scale deployment hello-api --replicas=5`

## Self-Healing
Killed a pod and Kubernetes replaced it automatically - the Deployment keeps reconciling the actual state toward the desired replica count. This is the core "desired state vs. actual state" loop of Kubernetes.

## Key Insight
Kubernetes doesn't care *which* pod you talk to - the Service abstracts over the pods, and the Deployment takes care of keeping the right number alive.