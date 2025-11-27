########################################
# COGNITO OUTPUTS
########################################

output "cognito_domain" {
  description = "Full Cognito Hosted UI domain (without https://)"
  value       = "${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com"
}

output "cognito_client_id" {
  description = "Cognito app client ID"
  value       = aws_cognito_user_pool_client.this.id
}

output "cognito_redirect_uri" {
  description = "Redirect URI used by Cognito Hosted UI"
  value       = local.callback_uri
}

output "cognito_logout_redirect_uri" {
  description = "Logout redirect URI"
  value       = local.logout_uri
}

output "cognito_region" {
  description = "AWS region for Cognito"
  value       = var.aws_region
}

output "cognito_scopes" {
  description = "Space-separated scopes"
  value       = "openid profile email"
}

output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.this.id
}

########################################
# FRONTEND (S3 + CLOUDFRONT) OUTPUTS
########################################

output "frontend_s3_bucket" {
  description = "S3 bucket for React app hosting"
  value       = aws_s3_bucket.frontend.bucket
}

output "frontend_cloudfront_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.frontend.id
}

output "frontend_cloudfront_domain" {
  description = "CloudFront domain"
  value       = aws_cloudfront_distribution.frontend.domain_name
}
