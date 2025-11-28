##########################################################
# COGNITO OUTPUTS
##########################################################

# The Hosted UI domain WITHOUT https://
output "cognito_domain" {
  description = "Full Cognito Hosted UI domain (without https://)"
  value       = "${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com"
}

# Full Hosted UI domain WITH https://
output "cognito_hosted_ui_url" {
  description = "Full HTTPS URL to Cognito Hosted UI"
  value       = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com"
}

# Cognito client ID
output "cognito_client_id" {
  description = "Cognito app client ID"
  value       = aws_cognito_user_pool_client.this.id
}

# Callback / redirect URI
output "cognito_redirect_uri" {
  description = "Redirect URI used by Cognito Hosted UI"
  value       = local.callback_uri
}

# Logout redirect URI
output "cognito_logout_redirect_uri" {
  description = "Logout redirect URI"
  value       = local.logout_uri
}

# Region output
output "cognito_region" {
  description = "AWS region for Cognito"
  value       = var.aws_region
}

# Scopes
output "cognito_scopes" {
  description = "Space-separated scopes"
  value       = "openid profile email"
}

# User Pool ID
output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.this.id
}

##########################################################
# Fully Formed URLs
##########################################################

# Fully formed login URL (best for frontend and GitHub Actions)
output "cognito_login_url" {
  description = "Fully formed Cognito login URL (authorization endpoint)"
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com/oauth2/authorize?client_id=${aws_cognito_user_pool_client.this.id}&response_type=code&scope=openid+email+profile&redirect_uri=${local.callback_uri}"
}

# Fully formed logout URL
output "cognito_logout_url" {
  description = "Fully formed Cognito logout URL"
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com/logout?client_id=${aws_cognito_user_pool_client.this.id}&logout_uri=${local.logout_uri}"
}

##########################################################
# FE-friendly JSON
##########################################################

output "cognito_frontend_config" {
  description = "Combined Cognito config as JSON for UI apps"
  value = jsonencode({
    region      = var.aws_region
    userPoolId  = aws_cognito_user_pool.this.id
    clientId    = aws_cognito_user_pool_client.this.id
    domain      = "${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com"
    redirectUri = local.callback_uri
    logoutUri   = local.logout_uri
    scopes      = "openid profile email"
  })
}
