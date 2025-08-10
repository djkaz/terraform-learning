# Terraform IAM Role and Policy Setup with LocalStack

This project demonstrates how to create an IAM role and policy using Terraform, configured for local development with LocalStack.

---

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (version 0.12+ recommended)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [LocalStack](https://github.com/localstack/localstack) (for local AWS cloud services)
- [awslocal](https://github.com/localstack/awscli-local) (CLI wrapper for AWS CLI to interact with LocalStack)

---

## Setup Instructions

### 1. Install and Run LocalStack

```bash
# Using pip to install LocalStack
pip install localstack

# Start LocalStack
localstack start
Alternatively, if you prefer Docker:

docker run -d -p 4566:4566 -p 4571:4571 localstack/localstack
2. Configure AWS CLI for LocalStack
Make sure you have awslocal installed, which simplifies commands:

pip install awscli-local
3. Create the S3 Bucket
Run the following command to create your local S3 bucket:

awslocal --endpoint-url=http://localhost:4566 s3 mb s3://my-awesome-local-bucket --profile localstack
This sets up the bucket my-awesome-local-bucket in your local environment.

4. Initialize and Apply Terraform Configuration
Ensure your terraform provider configuration points to LocalStack (as in your main.tf):


provider "aws" {
  access_key               = "mock-access-key"
  secret_key               = "mock-secret-key"
  region                   = "us-east-1"
  skip_requesting_account_id = true
  endpoints {
    iam = "http://localhost:4566"
  }
}
Initialize Terraform:

terraform init
Apply the configuration:

terraform apply
Confirm the actions when prompted.

Notes
The Terraform configuration creates an IAM role and attaches a policy with read permissions for the specified S3 bucket and KMS.
All commands assume LocalStack is running locally on port 4566.
This setup is for local development/testing purposes only.
Cleanup
To delete the created resources:

terraform destroy
And to remove the S3 bucket:


awslocal --endpoint-url=http://localhost:4566 s3 rb s3://my-awesome-local-bucket --force
Additional Resources
Terraform AWS Provider Documentation
LocalStack GitHub Repository
AWS CLI Documentation
License
This project is for educational purposes only.


Feel free to customize further based on your project specifics!
