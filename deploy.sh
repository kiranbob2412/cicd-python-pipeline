#!/bin/bash

set -e

IMAGE="cicd-python-app"
CONTAINER="cicd-python-app"
PORT="8080"

echo "Starting deployment..."

# Preserve currently deployed image
if docker image inspect "${IMAGE}:latest" >/dev/null 2>&1; then
    docker tag "${IMAGE}:latest" "${IMAGE}:previous"
    echo "Previous version preserved."
fi

# Build new version
docker build -t "${IMAGE}:latest" .

# Stop current container
docker stop "$CONTAINER" 2>/dev/null || true
docker rm "$CONTAINER" 2>/dev/null || true

# Start new version
docker run -d \
  --name "$CONTAINER" \
  -p "${PORT}:8080" \
  -e APP_ENV="${APP_ENV:-production}" \
  "${IMAGE}:latest"

echo "Waiting for application..."
sleep 5

echo "Running health check..."

if curl --fail --silent "http://localhost:${PORT}/health"; then
    echo
    echo "Health check passed."
    echo "Deployment completed successfully."
else
    echo
    echo "Health check FAILED."
    echo "Rolling back..."

    docker stop "$CONTAINER" 2>/dev/null || true
    docker rm "$CONTAINER" 2>/dev/null || true

    docker run -d \
      --name "$CONTAINER" \
      -p "${PORT}:8080" \
      -e APP_ENV="${APP_ENV:-production}" \
      "${IMAGE}:previous"

    sleep 5

    curl --fail --silent "http://localhost:${PORT}/health"

    echo
    echo "Rollback completed successfully."
    exit 1
fi
