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