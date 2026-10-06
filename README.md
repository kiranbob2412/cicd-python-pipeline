# 🚀 CI/CD Python Application — Production-Style DevOps Pipeline

A production-oriented **CI/CD pipeline for a Python Flask application** implementing automated testing, Docker containerization, continuous integration, continuous deployment, health validation, rollback capability, environment configuration, and deployment observability.

---

## 🏗️ Architecture

```text
Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Checkout Code
    ├── Setup Python 3.12
    ├── Install Dependencies
    ├── Run Pytest
    └── Build Docker Image
    │
    ▼
CI PASSED
    │
    ▼
Self-Hosted Ubuntu Runner
    │
    ├── Checkout Code
    ├── Deploy Application
    ├── Docker
    ├── Gunicorn
    └── Health Check
    │
    ▼
Deployment Validation
    │
    ├── SUCCESS → Application Running
    │
    └── FAILURE → Automatic Rollback


🎯 Project Objectives
This project demonstrates a real-world DevOps CI/CD workflow instead of a basic GitHub Actions example.
Key objectives
Automate application testing
Automate Docker image builds
Automate application deployment
Use GitHub Actions
Use a self-hosted Ubuntu runner
Deploy Flask using Gunicorn
Implement application health checks
Implement automatic rollback
Implement manual rollback
Securely manage environment configuration
Collect deployment logs
Upload deployment artifacts
Maintain a clean Git workflow
Separate CI and CD responsibilities
🧰 Technology Stack
Category
Technology
Programming Language
Python 3.12
Framework
Flask
Production Server
Gunicorn
Testing
Pytest
Containerization
Docker
Container Management
Docker Compose
CI/CD
GitHub Actions
CD Runner
GitHub Self-Hosted Runner
Operating System
Ubuntu Linux
Automation
Bash
Version Control
Git + GitHub
Configuration
Environment Variables
Health Validation
HTTP Health Check
Logging
Docker Logs
Artifacts
GitHub Actions Artifacts
📁 Project Structure
cicd-python-pipeline/
│
├── app/
│   ├── __init__.py
│   └── main.py
│
├── tests/
│   └── test_main.py
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── cicd.yml
│
├── actions-runner/
│   └── # Self-hosted runner files
│
├── ci-logs/
│   └── # Deployment logs
│
├── deploy.sh
├── rollback.sh
├── docker-compose.yml
├── Dockerfile
├── .dockerignore
├── .gitignore
├── pytest.ini
├── requirements.txt
└── README.md
actions-runner/ is excluded from Git using .gitignore.
🔄 CI/CD Pipeline
Continuous Integration
Every push to the main branch triggers the CI pipeline.
Git Push
   ↓
Checkout Code
   ↓
Setup Python 3.12
   ↓
Install Dependencies
   ↓
Run Pytest
   ↓
Build Docker Image
   ↓
CI Passed
The CI pipeline ensures that the application passes automated tests before deployment.
🚀 Continuous Deployment
After CI succeeds, the deployment job runs on the self-hosted Ubuntu runner.
CI Success
     ↓
Self-Hosted Runner
     ↓
Checkout Code
     ↓
deploy.sh
     ↓
Preserve Previous Image
     ↓
Build New Docker Image
     ↓
Stop Existing Container
     ↓
Start New Container
     ↓
Health Check
     ↓
Deployment Success
Deployment is blocked if the CI stage fails.
🧪 Automated Testing
The project uses Pytest for automated testing.
Current tests include:
def test_add():
    assert add(2, 3) == 5


def test_add_negative():
    assert add(-2, 2) == 0
Run tests locally:
pytest -v
Expected result:
2 passed

🐳 Docker
The application is packaged as a Docker image.
Build Image
docker build -t cicd-python-app:latest .
Run Container
docker run -d \
  --name cicd-python-app \
  -p 8080:8080 \
  -e APP_ENV=production \
  cicd-python-app:latest
Check Container
docker ps
⚙️ Production Server — Gunicorn
The project uses Gunicorn instead of Flask's development server.
gunicorn --bind 0.0.0.0:8080 app.main:app
This provides a production-oriented WSGI application server.
🏥 Application Health Check
The application exposes:
GET /health
Test locally:
curl --fail http://localhost:8080/health
Expected response:
{
  "environment": "production",
  "status": "healthy"
}
The deployment script automatically performs this health check after deployment.
🔁 Automatic Rollback
The deployment process preserves the currently deployed image before building the new version.
Current Image
     ↓
cicd-python-app:latest
     ↓
Preserved
     ↓
cicd-python-app:previous
If the new deployment fails the health check:
New Deployment
      ↓
Health Check FAILED
      ↓
Stop New Container
      ↓
Remove Failed Container
      ↓
Start Previous Image
      ↓
Health Check
      ↓
Rollback Successful
This provides protection against failed deployments.
↩️ Manual Rollback
Manual rollback can be performed using:
./rollback.sh
The rollback script:
Stops the current container
Removes the container
Starts the previous Docker image
Waits for application startup
Performs a health check
Confirms rollback success
🔐 Environment Configuration
The application uses:
APP_ENV
Example:
APP_ENV=production
GitHub Actions uses a GitHub Secret:
DEPLOY_ENV
The workflow passes the secret to the deployment job:
env:
  APP_ENV: ${{ secrets.DEPLOY_ENV }}
Security Principle
Sensitive configuration should never be hard-coded inside source code.
🧩 Docker Compose
The project also supports Docker Compose.
Start Application
docker compose up -d --build
Check Container
docker ps
Health Check
curl http://localhost:8080/health
Stop Application
docker compose down
🖥️ Self-Hosted GitHub Runner
The CD stage runs on an Ubuntu Linux machine using a GitHub self-hosted runner.
Runner name:
ubuntu-cicd-runner
Start the runner:
./run.sh
Expected state:
Connected to GitHub
Listening for Jobs
The runner executes deployment jobs directly on the Ubuntu environment.
📊 Deployment Observability
The deployment workflow collects application and container information.
Generated deployment information includes:
ci-logs/
├── application.log
└── container-inspect.json
These files are uploaded as GitHub Actions artifacts.
This makes troubleshooting failed deployments easier.
🛡️ Failure Handling
The deployment process follows a defensive deployment model:
Build
  ↓
Deploy
  ↓
Wait
  ↓
Health Check
  │
  ├── PASS
  │    ↓
  │ Deployment Success
  │
  └── FAIL
       ↓
    Rollback
       ↓
Previous Version
       ↓
Health Check
The deployment script uses:
set -e
to stop execution when critical commands fail.
🔧 Deployment Script
The main deployment automation is implemented in:
deploy.sh
Responsibilities:
Preserve previous image
Build new Docker image
Stop existing container
Remove existing container
Start new container
Configure environment variables
Wait for application startup
Perform health check
Automatically rollback on failure
🔄 CI/CD Workflow Files
ci.yml
The CI workflow performs:
Checkout
   ↓
Python Setup
   ↓
Install Dependencies
   ↓
Run Tests
   ↓
Docker Build
cicd.yml
The complete pipeline performs:
CI
 ↓
Automated Tests
 ↓
Docker Build
 ↓
Self-Hosted Deployment
 ↓
Health Check
 ↓
Deployment Logs
 ↓
GitHub Artifacts
The deployment job depends on CI:
needs: test-and-build
Therefore, deployment cannot proceed when CI fails.


🧠 DevOps Concepts Demonstrated
This project demonstrates practical experience with:
CI/CD pipeline design
Git workflow
GitHub Actions
Automated testing
Docker
Docker Compose
Container lifecycle management
Gunicorn
Flask
Linux administration
Bash scripting
Self-hosted runners
Environment variables
GitHub Secrets
Health checks
Deployment validation
Rollback strategy
Deployment observability
GitHub Actions artifacts
Failure handling
Reproducible deployments
🏗️ Production Engineering Principles
1. Fail Fast
Testing happens before deployment.
2. Automated Validation
A deployment is not considered successful until the health check passes.
3. Rollback Safety
The previous Docker image is preserved before deployment.
4. Immutable Application Artifact
The application is packaged into a Docker image.
5. Configuration Separation
Runtime configuration is separated from application source code.
6. Automation
Deployment logic is implemented as version-controlled Bash scripts.
7. Observability
Deployment logs and container information are collected as artifacts.
📈 Architecture
                    ┌─────────────────────┐
                    │      Developer      │
                    └──────────┬──────────┘
                               │
                            git push
                               │
                               ▼
                    ┌─────────────────────┐
                    │       GitHub        │
                    │     Repository      │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │   GitHub Actions    │
                    │                     │
                    │  Automated Tests    │
                    │         +           │
                    │   Docker Build      │
                    └──────────┬──────────┘
                               │
                          CI SUCCESS
                               │
                               ▼
                 ┌──────────────────────────┐
                 │ Self-Hosted Ubuntu Runner│
                 │                          │
                 │        deploy.sh         │
                 │            │             │
                 │            ▼             │
                 │          Docker          │
                 │            │             │
                 │            ▼             │
                 │        Gunicorn          │
                 │            │             │
                 │            ▼             │
                 │        Flask App         │
                 └────────────┬─────────────┘
                              │
                              ▼
                         /health
                              │
                     ┌────────┴────────┐
                     │                 │
                   PASS              FAIL
                     │                 │
                     ▼                 ▼
                 SUCCESS           ROLLBACK
                                       │
                                       ▼
                              Previous Image


👨‍💻 Author
KUCHIPUDI KIRAN BABU
B.Tech — Mechanical Engineering
Cloud / DevOps Engineer Aspirant

⭐ Project Philosophy
Build it. Automate it. Test it. Deploy it. Monitor it. Recover it.
