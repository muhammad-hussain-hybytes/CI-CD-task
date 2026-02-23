# Stage 1: Builder Stage - Dependencies install karo
FROM python:3.9-slim-bookworm AS builder

WORKDIR /app

# System dependencies update with security fixes
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy requirements with exact secure versions
COPY requirements.txt .

# Upgrade pip and install dependencies with force-reinstall to avoid cache issues
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --force-reinstall -r requirements.txt

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
