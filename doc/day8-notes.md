# Day 8 — Security & DevSecOps notes

## One finding fixed: `perl-base` CRITICALs (CVE-2026-13221, CVE-2026-42496, CVE-2026-8376)

Trivy flagged **3 CRITICAL** vulnerabilities in `perl-base` (`5.40.1-6`) shipped inside the `python:3.11-slim` base image. Refreshing the base image to the newest `python:3.11-slim` did **not** clear them, because the patched Debian package `5.40.1-6+deb13u1` is only reachable through a package upgrade, not a newer image snapshot — so I pinned the package in the `Dockerfile` with `RUN apt-get update && apt-get install -y --only-upgrade perl-base && rm -rf /var/lib/apt/lists/*`.

Rescan: **CRITICAL 3 → 0**, overall OS total 178 → 165. This is why the CI gate lives *before* `docker push`: a problematic image never ships.