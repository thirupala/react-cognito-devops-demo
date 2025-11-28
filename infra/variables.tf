

variable "aws_region" {
  description = "AWS region name"
  type        = string
  default     = "us-east-1"
}

variable "app_base_url" {
  description = "Base URL of the frontend application"
  type        = string
  default     = "http://localhost:3000"
}

variable "cognito_domain_prefix" {
  description = "Cognito custom domain prefix (deprecated - using random suffix)"
  type        = string
  default     = "development-demo-app"
}

variable "project_name" {
  description = "Name used for resource prefixes"
  type        = string
  default     = "react-demo-app"
}

variable "github_org" {
  description = "GitHub organization or username"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}
variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}