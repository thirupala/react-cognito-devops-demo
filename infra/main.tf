terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # Profile commented out for GitHub Actions compatibility
  # Use AWS_PROFILE environment variable for local development
}

locals {
  callback_uri = "${var.app_base_url}/callback"
  logout_uri   = var.app_base_url
}

########################################
# RANDOM SUFFIX FOR UNIQUE NAMING
########################################

resource "random_id" "cognito_suffix" {
  byte_length = 3
}

########################################
# COGNITO USER POOL
########################################

resource "aws_cognito_user_pool" "this" {
  name = "${var.project_name}-user-pool"

  auto_verified_attributes = ["email"]

  username_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 5
      max_length = 2048
    }
  }
}

########################################
# COGNITO APP CLIENT
########################################

resource "aws_cognito_user_pool_client" "this" {
  name         = "${var.project_name}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.this.id

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid", "email", "profile"]

  callback_urls = [
    local.callback_uri
  ]

  logout_urls = [
    local.logout_uri
  ]

  generate_secret = false

  supported_identity_providers = ["COGNITO"]

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  prevent_user_existence_errors = "ENABLED"
}

########################################
# COGNITO HOSTED UI DOMAIN (with unique suffix)
########################################

resource "aws_cognito_user_pool_domain" "this" {
  # Fixed typo: develeopment -> development
  # Added random suffix for uniqueness
  domain       = "development-demo-app-${random_id.cognito_suffix.hex}"
  user_pool_id = aws_cognito_user_pool.this.id
}