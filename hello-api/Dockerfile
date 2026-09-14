# Build stage
FROM python:3.11-slim AS builder

WORKDIR /app

# Create virtualenv
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# Final stage
FROM python:3.11-slim

WORKDIR /app

# Copy virtualenv from builder stage (only the installed packages, no pip cache or build tools)
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy application code
COPY main.py .

# Pin perl-base to patched version (CVE-2026-13221 etc.)
RUN apt-get update && apt-get install -y --only-upgrade perl-base && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN adduser --disabled-password appuser

# Let the app user own the app directory
RUN chown -R appuser /app

# Switch to non-root
USER appuser

# Run the app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
