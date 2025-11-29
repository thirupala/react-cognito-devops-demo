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

  # ADD THIS NEW STATEMENT
  statement {
    sid    = "TerraformStateLocking"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [
      "arn:aws:dynamodb:us-east-1:727588137294:table/terraform-state-lock"
    ]
  }

  # ADD THIS NEW STATEMENT  
  statement {
    sid    = "TerraformStateStorage"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::react-cognito-terraform-state-*/terraform.tfstate",
      "arn:aws:s3:::react-cognito-terraform-state-*/*"
    ]
  }

  statement {
    sid    = "TerraformStateBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::react-cognito-terraform-state-*"
    ]
  }
}
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

resource "aws_iam_role" "github_oidc_frontend" {
  name               = "github-oidc-frontend-role"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_terraform_assume_role.json
}

data "aws_iam_policy_document" "github_oidc_frontend_policy" {
  statement {
    sid    = "ListFrontendBucket"
    effect = "Allow"
    actions = ["s3:ListBucket"]
    resources = [aws_s3_bucket.frontend.arn]
  }

  statement {
    sid    = "ObjectAccessFrontendBucket"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${aws_s3_bucket.frontend.arn}/*"]
  }

  statement {
    sid    = "CloudFrontInvalidation"
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_oidc_frontend_attach" {
  role   = aws_iam_role.github_oidc_frontend.name
  policy = data.aws_iam_policy_document.github_oidc_frontend_policy.json
}
