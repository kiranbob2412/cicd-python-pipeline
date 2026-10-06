#!/bin/bash

set -e

echo "Starting deployment..."

docker stop cicd-python-app 2>/dev/null || true
docker rm cicd-python-app 2>/dev/null || true

docker build -t cicd-python-app:latest .

docker run -d \
  --name cicd-python-app \
  -p 8080:8080 \
  -e APP_ENV="${APP_ENV:-production}" \
  cicd-python-app:latest

echo "Waiting for application..."

sleep 5

echo "Running health check..."

curl --fail --silent http://localhost:8080/health

echo
echo "Health check passed."
echo "Deployment completed successfully."
