# Day 8 Notes

## Shift Left
Catch security issues at **build time**, not after deployment. A vulnerable dependency caught in CI costs nothing; the same one found in production after a breach costs everything.

## Container Hardening Basics
- Run as a **non-root user** (root in a container = root on the host if the container escapes)
- Use **minimal base images** (fewer packages = smaller attack surface)
- **Don't bake secrets into image layers** — they persist in layer history even if a later layer "deletes" them

## Secrets Management
- Environment variables injected **at runtime** (GitHub Secrets, vaults) — never git commit a credential, ever
- Secret rotation + least privilege: scoped tokens that can be revoked

## Extra Notes (day-of)
- Scans come in layers: dependency scan (pip-audit), Dockerfile lint (hadolint), image scan (Trivy), SAST (semgrep/bandit)
- GitHub Actions security: review third-party action pins, don't use untrusted `pull_request_target`