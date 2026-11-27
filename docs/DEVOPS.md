# Commune — DevOps Infrastructure & CI/CD

## Project Overview

This project demonstrates the implementation of a DevOps environment for Commune, an existing full-stack web application.

The original application was developed by another developer. My contribution focused on containerization, infrastructure provisioning, server configuration, CI/CD automation, and cloud deployment.

The goal was to deploy the application on AWS using modern DevOps tools and automate the testing and deployment process.

## Technologies Used

| Category | Technologies |
|---|---|
| Cloud | AWS EC2, IAM, Systems Manager (SSM) |
| Infrastructure as Code | Terraform |
| Configuration Management | Ansible |
| Containers | Docker, Docker Compose |
| Reverse Proxy | Nginx |
| CI/CD | GitHub Actions |
| Cloud Authentication | GitHub OIDC, AWS IAM Roles |
| Operating System | Ubuntu Linux |
| Version Control | Git, GitHub |
| Database | MongoDB |

## Architecture

The application runs on an AWS EC2 instance using Docker Compose.

The deployment includes four services:

- **Web:** Frontend application served by Nginx.
- **API:** Backend service handling HTTP requests.
- **Realtime:** Service providing real-time communication.
- **MongoDB:** Database used by the application.

Nginx serves the frontend and forwards API requests to the backend through the internal Docker network.

The API and MongoDB services are not directly exposed to the public internet in the production Docker Compose configuration.

## 1. Containerization with Docker

Containerized the application's services using Dockerfiles and Docker Compose.

Main tasks:

- Created and configured Dockerfiles for the web, API, and realtime services.
- Used multi-stage builds where appropriate.
- Configured Docker Compose to manage the application's services.
- Set up internal container networking.
- Configured environment variables for local and production environments.
- Configured Nginx as a web server and reverse proxy.
- Tested the containerized application locally.

**Relevant files:**

- `docker-compose.yml`
- `docker-compose.prod.yml`
- `apps/web/Dockerfile`
- `apps/api/Dockerfile`

## 2. AWS Infrastructure with Terraform

Used Terraform to provision an AWS EC2 instance.

Infrastructure configuration:

- AWS Region: `eu-north-1` (Stockholm).
- Operating System: Ubuntu 24.04.
- Instance Type: `t3.small`.
- Storage: 30 GB encrypted gp3 EBS volume.
- Configured VPC subnet and security group associations.
- Enabled a public IP address.
- Enforced IMDSv2 for EC2 metadata access.
- Configured Terraform outputs for the instance ID and public IP.

Some AWS resources and permissions were configured separately through the AWS Console.

**Relevant file:** `terraform/main.tf`

## 3. Server Configuration with Ansible

Used Ansible to automate the configuration of the Ubuntu EC2 server.

The Ansible playbook:

- Updates the system package cache.
- Installs Git, Python, curl, and required dependencies.
- Configures the official Docker package repository.
- Installs Docker Engine and Docker Compose.
- Starts and enables the Docker service.
- Configures the Ubuntu user for Docker access.
- Creates the application directory.
- Verifies the Docker installation.

**Relevant files:**

- `ansible/playbook.yml`
- `ansible/inventory.example.ini`

## 4. Continuous Integration (CI)

Implemented a CI pipeline using GitHub Actions.

The pipeline performs:

1. Dependency installation.
2. Type checking.
3. Automated tests.
4. Application builds.
5. Docker image builds.

The CI workflow runs automatically for configured pushes and pull requests.

**Relevant file:** `.github/workflows/ci.yml`

## 5. Continuous Deployment (CD)

Implemented automated deployment to AWS using GitHub Actions and AWS Systems Manager.

The deployment process:

1. Code is pushed to the `main` branch.
2. The CI pipeline validates the application.
3. After successful CI, the deployment workflow is triggered.
4. GitHub Actions authenticates to AWS using OIDC and an IAM Role.
5. AWS Systems Manager sends deployment commands to the EC2 instance.
6. The server retrieves the approved Git revision.
7. Docker Compose builds and starts the application services.
8. A smoke test verifies the API health endpoint.

Using AWS Systems Manager avoids requiring SSH access from the GitHub Actions runner.

OIDC authentication avoids storing long-lived AWS access keys in GitHub secrets.

**Relevant file:** `.github/workflows/deploy.yml`

## 6. Security

Security practices implemented during the project:

- IAM role-based authentication.
- GitHub OIDC integration with AWS.
- Restricted SSH access using AWS Security Groups.
- IMDSv2 requirement on the EC2 instance.
- Encrypted EBS storage.
- Internal Docker networking for the API and MongoDB.
- Environment files excluded from Git.
- Terraform state files and private SSH keys excluded from Git.

This deployment was created as a learning and portfolio environment rather than a fully hardened production service.

## 7. Testing and Verification

Verified the application and deployment using:

- Local Docker Compose tests.
- Docker container status checks.
- Automated GitHub Actions CI checks.
- GitHub Actions deployment results.
- AWS Systems Manager command results.
- HTTP smoke testing.

The API health check returned HTTP 200 with a successful status response.

## 8. Troubleshooting

Several technical issues were investigated during the project.

### GitHub OIDC Authentication

The initial AWS IAM trust policy did not match the OIDC subject sent by GitHub Actions.

Updated the trust policy to match the actual repository identity and successfully authenticated to AWS.

### AWS Systems Manager Shell Error

A deployment command failed because the default shell did not support `pipefail`.

Updated the deployment script to execute with Bash.

### Git Synchronization

A push was rejected because the remote repository contained newer commits.

Synchronized the local branch with the remote branch before pushing successfully.

### SSH Connectivity

Investigated SSH connectivity problems involving network access and security group configuration.

Continued server management and deployment using AWS Systems Manager.

## 9. AWS Cost Management

The AWS environment was created for practical learning and portfolio development.

Cost management included:

- Monitoring AWS usage and remaining credits.
- Configuring AWS Budgets and alerts.
- Stopping the EC2 instance between practice sessions.
- Reviewing infrastructure resources and persistent storage.
- Planning resource cleanup after project completion.

## Future Improvements

Potential future improvements include:

- Custom domain and HTTPS using TLS certificates.
- Additional monitoring and alerting.
- Managing more AWS resources through Terraform.
- Further IAM and security hardening.
- Additional infrastructure and deployment automation.

## Project Credits

The Commune application was originally developed by another developer.

My work focused on the DevOps implementation, including Docker, Terraform, Ansible, AWS infrastructure, GitHub Actions CI/CD, deployment automation, and troubleshooting.

This repository demonstrates practical DevOps experience using an existing full-stack application.
