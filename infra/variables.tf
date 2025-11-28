############################################################
# AWS CONFIGURATION
############################################################

variable "aws_region" {
  description = "AWS region name"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "AWS region must not be empty."
  }
}

variable "aws_account_id" {
  description = "AWS Account ID (12-digit)"
  type        = string

  validation {
    condition     = can(regex("^\\d{12}$", var.aws_account_id))
    error_message = "AWS Account ID must be a 12-digit number."
  }
}

############################################################
# APPLICATION SETTINGS
############################################################

variable "project_name" {
  description = "Name used for resource prefixes"
  type        = string
  default     = "react-cognito-demo"
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "staging", "prod", "production"], var.environment)
    error_message = "Environment must be one of: dev, stage/staging, prod/production."
  }
}

variable "app_base_url" {
  description = "Base URL of the frontend application (CloudFront or ALB URL)"
  type        = string
  default     = "http://localhost:3000"

  validation {
    condition     = can(regex("^(http|https)://", var.app_base_url))
    error_message = "app_base_url must begin with http:// or https://."
  }
}

############################################################
# GITHUB OIDC CONFIGURATION
############################################################

variable "github_org" {
  description = "GitHub organization or username"
  type        = string

  validation {
    condition     = length(var.github_org) > 0
    error_message = "github_org cannot be empty."
  }
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.github_repo))
    error_message = "github_repo contains invalid characters."
  }
}
