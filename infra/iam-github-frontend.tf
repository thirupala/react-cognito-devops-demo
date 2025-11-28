#######################################################
# IAM ROLE FOR GITHUB OIDC (FRONTEND PIPELINE)
#######################################################

data "aws_iam_policy_document" "github_oidc_frontend_assume_role" {
  statement {
    sid    = "GitHubOidcAssumeRole"
    effect = "Allow"

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
      ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    # Restrict which GitHub repo/branch can assume this role
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        # repo:OWNER/REPO:ref:refs/heads/BRANCH
        "repo:thirupala/react-cognito-devops-demo:ref:refs/heads/main",
      ]
    }

    # Recommended: ensure audience is sts.amazonaws.com
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "github_oidc_frontend" {
  name               = "github-oidc-frontend-role"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_frontend_assume_role.json

  description = "Role assumed by GitHub Actions (frontend build/deploy) via GitHub OIDC"

  tags = {
    Name        = "github-oidc-frontend-role"
    Environment = var.environment
    Project     = var.project_name
  }
}

output "github_oidc_frontend_role_arn" {
  description = "IAM role ARN for GitHub OIDC frontend pipeline"
  value       = aws_iam_role.github_oidc_frontend.arn
}
