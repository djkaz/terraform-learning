# main.tf

# 1. Configure the AWS Provider
#    This tells Terraform to use a specific region and
#    provides dummy credentials for LocalStack.
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true # Recommended for LocalStack S3

  # Configure the endpoint for LocalStack
  endpoints {
    s3 = "http://localhost:4566"
  }
}

# 2. Define the resource you want to create
#    This is the declarative part of Terraform.
resource "aws_s3_bucket" "my_first_local_bucket" {
  bucket = "my-awesome-local-bucket"
}