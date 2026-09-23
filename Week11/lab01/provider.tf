provider "aws" {
  access_key = "your_aws_access_key_id"
  secret_key = "your_aws_secret_access_key"
  token      = "your_aws_session_token"
  region     = "us-east-1"
  default_tags {
    tags = {
      Course    = "IPA-Terraform"
      ManagedBy = "Terraform"
    }
  }
}
