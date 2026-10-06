#!/bin/bash

set -e

echo "Starting rollback..."

docker stop cicd-python-app 2>/dev/null || true
docker rm cicd-python-app 2>/dev/null || true

docker run -d \
  --name cicd-python-app \
  -p 8080:8080 \
  -e APP_ENV=production \
  cicd-python-app:previous

echo "Waiting for previous version..."

sleep 5

echo "Checking previous version health..."

curl --fail --silent http://localhost:8080/health

echo
echo "Rollback health check passed."
echo "Rollback completed successfully."
