data "aws_iam_policy_document" "github_oidc_terraform_assume_role" {
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

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "github_oidc_terraform" {
  name               = "github-oidc-terraform-role"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_terraform_assume_role.json
}

data "aws_iam_policy_document" "github_oidc_terraform_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "cloudfront:*",
      "cognito-idp:*",
      "iam:PassRole",
      "iam:GetRole",
      "iam:ListRolePolicies",
      "iam:AttachRolePolicy",
      "iam:CreateRole",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_oidc_terraform_attach" {
  role   = aws_iam_role.github_oidc_terraform.name
  policy = data.aws_iam_policy_document.github_oidc_terraform_policy.json
}
