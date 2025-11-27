variable "aws_region" {
  description = "AWS region name"
  type        = string
  default     = "us-east-1"
}

variable "app_base_url" {
  description = "Base URL of the frontend application"
  type        = string
  # For local dev; in real envs override via TF var or tfvars
  default     = "http://localhost:3000"
}

variable "cognito_domain_prefix" {
  description = "Cognito custom domain prefix (must be globally unique in region)"
  type        = string
  default     = "develeopment-demo-app-123456"
}

variable "project_name" {
  description = "Name used for resource prefixes (S3 bucket, CloudFront, etc.)"
  type        = string
  default     = "react-demo-app"
}
