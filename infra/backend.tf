terraform {
  backend "s3" {
    bucket         = "react-cognito-terraform-state-727588137294"  # Your account ID
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
