data "aws_iam_policy_document" "github_oidc_frontend_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:thirupala/react-cognito-devops-demo:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "github_oidc_frontend" {
  name               = "github-oidc-frontend-role"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_frontend_assume_role.json
}
