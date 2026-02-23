# Stage 1: Builder Stage - Dependencies install karo
FROM python:3.9-slim-bookworm AS builder

WORKDIR /app

# System dependencies update karo (important!)
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Python dependencies - specific versions jinka vulnerabilities fixed hain
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip uninstall -y pip && \
    find /usr/local/lib/python3.9/site-packages/ -name "*.pyc" -delete

# Stage 2: Distroless Image - Final production image
FROM gcr.io/distroless/python3-debian12:latest

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY app.py .

# Non-root user use kar rahe hain (security best practice)
USER nonroot:nonroot

EXPOSE 5000 8000

CMD ["app.py"]
