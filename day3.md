# Day 3 Notes

## Image vs. Container
- Image: static, read-only template (the recipe)
- Container: a running instance of that image (the result)

## Layer Caching
Docker builds layers, and each `COPY`/`RUN` step can be cached and reused if nothing before it changed. So `COPY requirements.txt` + `pip install` goes *before* copying app code - dependency install only rebuilds when requirements change, not on every code edit.

## hello-api in Docker
Built a FastAPI app into an image and ran it with Docker, reachable via `curl localhost:8000`.

## Multi-stage Builds
Used a builder stage to create a venv and install deps, then a slim final stage that only copies the installed packages - the production image drops build tools and the pip cache, keeping it small.