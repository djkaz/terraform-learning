terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

provider "aws" {
  access_key               = "mock-access-key"
  secret_key               = "mock-secret-key"
  region                   = "us-east-1"
  skip_requesting_account_id = true
  endpoints {
    iam = "http://localhost:4566"
  }
}

resource "aws_iam_role" "test_role" {
    name = "test_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

output "role_arn" {
  value = aws_iam_role.test_role.arn
}
