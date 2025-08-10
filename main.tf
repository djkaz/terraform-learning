terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

provider "aws" {
  access_key               = "test"
  secret_key               = "test"
  region                   = "us-east-1"
  skip_requesting_account_id = true
  endpoints {
    iam = "http://localhost:4566"
  }
}


# Create an IAM role
resource "aws_iam_role" "read_role" {
  name = "read_kms_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Create an IAM policy for KMS and S3 read access
resource "aws_iam_policy" "read_policy" {
  name        = "read_kms_s3_policy"
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::my-awesome-local-bucket",
          "arn:aws:s3:::my-awesome-local-bucket/*"
        ]
    },
        {
            Effect = "Allow"
            Action = [
            "kms:DescribeKey",
            "kms:ListAliases"
            ]
            Resource = "*"
        }
        ]
    })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "read_policy_attachment" {
    role = aws_iam_role.read_role.name
    policy_arn = aws_iam_policy.read_policy.arn
}
