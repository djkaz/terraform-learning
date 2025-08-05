terraform {
    required_version = ">= 0.12"
    backend "local" {
      
    }
}

provider "aws" {
    region = "us-east-1"
    access_key = "test"
    secret_key = "test"
    skip_credentials_validation = true
    endpoints {
        #ec2 = "http://localhost:4566"
        iam = "http://localhost:4567"
    }
}

resource "aws_iam_role" "test_role" {
    name = "test_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
}
