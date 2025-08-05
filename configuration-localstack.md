LocalStack + Terraform Setup Guide
This guide walks you through starting LocalStack, creating resources with AWS CLI, and managing infrastructure with Terraform locally.

Prerequisites
Docker installed and running
Python 3.x installed
AWS CLI installed (awslocal is used for LocalStack)
Terraform and tflocal (Terraform wrapper for local testing)
MacBookPro (or similar macOS device)
1. Starting LocalStack
Run LocalStack in detached mode:


localstack start -d
You should see the LocalStack logo and status messages indicating services are starting.

2. Check Service Status
Verify which services are available:

CopyRun
localstack status services
Sample output:

Service	Status
S3	✔ available
DynamoDB	✔ available
IAM	✔ available
Lambda	✔ available
...	...
3. Create AWS Resources with AWS CLI
Use awslocal to interact with LocalStack:

CopyRun
awslocal sqs create-queue --queue-name sample-queue
This creates a sample SQS queue:


{
    "QueueUrl": "http://sqs.us-east-1.localhost.localstack.cloud:4566/000000000000/sample-queue"
}

4. Initialize Terraform with LocalStack
Make sure your Terraform backend and providers are configured to point to LocalStack endpoints. Then, initialize your project:

tflocal init
You should see confirmation of successful initialization.

5. Plan and Apply Infrastructure Changes
Run a plan:

tflocal plan
Review the planned actions, then execute:

tflocal apply
Confirm with yes when prompted.

This creates resources defined in your Terraform configuration, such as S3 buckets or DynamoDB tables.

6. Verify Resources
List your S3 buckets:

awslocal s3 ls
You should see your buckets listed, e.g.:

2025-08-05 00:49:26 my-awesome-local-bucket
Troubleshooting Tips

Parse errors in Zsh: Ensure you’re not accidentally double-typing commands with % symbols or incomplete commands.
Service status issues: Restart LocalStack if some services aren’t available.
Resource creation failures: Confirm your AWS CLI commands target the correct LocalStack endpoints.
Final Notes
Use tflocal instead of terraform to ensure commands run against your local environment.
Configure your Terraform provider with LocalStack endpoints, e.g.:
CopyRun
provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"
  endpoints {
    s3 = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    # Add other services as needed
  }
}
