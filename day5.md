# Day 5 Notes

## What a Pipeline Is
A pipeline is just a YAML file (`workflow`) describing stages that run on GitHub's servers (called "runners"), triggered by events like `push`. The same file lives in the repo, so the CI setup is versioned like code.

## Secrets
Sensitive values like a Docker Hub password get stored in GitHub Settings → Secrets, and referenced in the workflow as variables (e.g. `${{ secrets.DOCKER_PASSWORD }}`) — never hardcoded in the YAML. The secret stays masked and out of the repo, so the file itself is safe to share.

## Gating Deployment
A good pipeline gates deployment: if tests fail, the image never gets built or pushed. The pipeline only advances to later stages when earlier ones pass, so broken code can't reach production.

## Key Insight
CI/CD is the automation of the Day 1 loop (build → test → deploy). The runner replaces my hands; the YAML replaces my memory.