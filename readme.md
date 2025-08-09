# LocalStack + Terraform: Mock IAM Role Example

This project demonstrates how to use [LocalStack](https://github.com/localstack/localstack) with [Terraform](https://www.terraform.io/) to simulate provisioning an AWS IAM Role locally. LocalStack allows you to develop and test AWS cloud infrastructure code offline by mocking AWS services.

## Prerequisites

- [Docker](https://www.docker.com/) installed and running
- [Terraform](https://www.terraform.io/downloads.html) installed
- LocalStack container running

## 1. Start LocalStack

Run LocalStack using Docker:

```bash
docker run -d -p 4566:4566 -p 4571:4571 localstack/localstack
```

This exposes LocalStack services on port 4566.

## 2. Terraform Configuration

Create a directory for your Terraform project. Inside it, create a file called `main.tf` and add the following:

```hcl
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
```

## 3. Initialize and Apply

Run these commands from your project directory:

```bash
terraform init
terraform apply
```

Terraform will show the planned actions. Type `yes` to proceed. The ARN of the created IAM role will be output at the end.

## 4. Verify with AWS CLI

You can verify the role exists in LocalStack using the AWS CLI:

Set environment variables (if you have not already):

```bash
export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
```

Then run:

```bash
aws --endpoint-url=http://localhost:4566 --region=us-east-1 iam list-roles
```

Example output:

```json
{
    "Roles": [
        {
            "Path": "/",
            "RoleName": "test_role",
            "RoleId": "AROAQAAAAAAAJ7VYEFEM3",
            "Arn": "arn:aws:iam::000000000000:role/test_role",
            "CreateDate": "2025-08-09T21:07:19.729236+00:00",
            "AssumeRolePolicyDocument": {
                "Statement": [
                    {
                        "Action": "sts:AssumeRole",
                        "Effect": "Allow",
                        "Principal": {
                            "Service": "ec2.amazonaws.com"
                        }
                    }
                ],
                "Version": "2012-10-17"
            },
            "MaxSessionDuration": 3600
        }
    ]
}
```

## Notes

- LocalStack's IAM service is a mock and does not provide all features of AWS IAM.
- Use this setup to test and validate your Terraform IAM resources locally.
- For production and complete feature support, use an actual AWS account.
