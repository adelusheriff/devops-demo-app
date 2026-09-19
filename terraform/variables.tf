variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Used to tag/name all resources"
  type        = string
  default     = "devops-demo"
}

variable "instance_type" {
  description = "EC2 instance size for the single app server (hosts staging + prod containers)"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "RDS instance size (production database only - staging uses a local container, see user_data.sh.tpl)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_multi_az" {
  description = "Enable Multi-AZ RDS for automatic failover. Roughly doubles RDS cost - leave false until prod traffic/SLA justifies it."
  type        = bool
  default     = false
}

variable "github_org" {
  description = "GitHub org or username that owns the repo, e.g. 'yourname'"
  type        = string
}

variable "github_repo" {
  description = "Repo name, e.g. 'devops-cicd-assignment'"
  type        = string
}

variable "staging_db_password" {
  description = "Password for the staging Postgres container running on the EC2 host"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Name of the production application database"
  type        = string
  default     = "devops_demo"
}

variable "db_username" {
  description = "Master username for production RDS"
  type        = string
  default     = "app_admin"
}

variable "db_password" {
  description = "Master password for production RDS"
  type        = string
  sensitive   = true
}

variable "monthly_budget_usd" {
  description = "Monthly AWS budget threshold - triggers an email alert at 80% and 100%"
  type        = string
  default     = "30"
}

variable "budget_alert_email" {
  description = "Email address to receive AWS Budget alerts"
  type        = string
}
