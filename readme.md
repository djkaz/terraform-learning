# LocalStack + Terraform: Mock EC2 Example

This project demonstrates how to use [LocalStack](https://github.com/localstack/localstack) with [Terraform](https://www.terraform.io/) to simulate provisioning an EC2 instance locally. LocalStack provides a fully functional local AWS cloud stack, so you can develop and test cloud infrastructure code offline.

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

Create a directory for your Terraform project. Inside it, create a file called `main.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  endpoints {
    ec2 = "http://localhost:4566"
  }
}
```

## 3. Define the EC2 Instance

Add the following to `main.tf`:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI ID; not used by LocalStack
  instance_type = "t2.micro"

  tags = {
    Name = "Localstack-EC2"
  }
}
```

> **Note:** LocalStack's EC2 service is a mock and does not create real virtual machines. This configuration is mainly for testing Terraform and AWS provider setup.

## 4. Initialize and Apply

Run these commands from your project directory:

```bash
terraform init
terraform apply
```

Terraform will show the planned actions. Type `yes` to proceed.

## 5. Interact with the Mock EC2 API

Although no real EC2 instance is created, you can use AWS CLI or SDKs to interact with LocalStack’s EC2 endpoint and verify your infrastructure code:

```bash
aws --endpoint-url=http://localhost:4566 ec2 describe-instances
```

Or with [awslocal](https://github.com/localstack/awscli-local):

```bash
awslocal --region=us-east-1 ec2 describe-instances
```

Example output:

```json
{
    "Reservations": [
        {
            "ReservationId": "r-707ffee7e3c7f7ef2",
            "OwnerId": "000000000000",
            "Groups": [],
            "Instances": [
                {
                    "Architecture": "x86_64",
                    "InstanceType": "t2.micro",
                    "Tags": [
                        {"Key": "Name", "Value": "Localstack-EC2"}
                    ],
                    ...
                }
            ]
        }
    ]
}
```

## Important Notes

- LocalStack's EC2 mock service is limited and does not support all features of real EC2.
- Use this setup to test and validate your cloud automation code locally.
- For full feature testing, use an actual AWS account.

---

Feel free to customize or extend this setup for your own requirements!
