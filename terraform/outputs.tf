output "app_public_ip" {
  description = "Public IP of the app server - staging on :8080, prod on :80"
  value       = aws_instance.app.public_ip
}

output "ec2_instance_id" {
  description = "Used by GitHub Actions to target ssm send-command, and for `aws ssm start-session` when debuggin"
  value       = aws_instance.app.id
}

output "ecr_repository_url" {
  description = "Push/pull images here - set as ECR_REPOSITORY_URL GitHub Actions variable"
  value       = aws_ecr_repository.app.repository_url
}

output "github_actions_role_arn" {
  description = "Set as the AWS_DEPLOY_ROLE_ARN GitHub Actions variable - no AWS keys needed"
  value       = aws_iam_role.github_actions.arn
}

output "prod_db_endpoint" {
  description = "RDS endpoint (host:port) - host portion is the production DB_HOST GitHub secret"
  value       = aws_db_instance.app.address
}

output "prod_db_name" {
  value = aws_db_instance.app.db_name
}
