#!/bin/bash
# Runs once on first boot.
set -e

apt-get update -y
apt-get install -y docker.io awscli
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

snap start amazon-ssm-agent || true

docker network create appnet || true

docker volume create staging-db-data || true
docker run -d \
  --name staging-db \
  --network appnet \
  --restart unless-stopped \
  -e POSTGRES_DB=devops_demo_staging \
  -e POSTGRES_USER=staging_app \
  -e POSTGRES_PASSWORD='${staging_db_password}' \
  -v staging-db-data:/var/lib/postgresql/data \
  postgres:16-alpine

echo "Bootstrap complete: docker, awscli, appnet, and staging-db are ready."
echo "ECR repository for this app: ${ecr_repository_url}"
echo "Region: ${aws_region}"
