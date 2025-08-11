# LocalStack Terraform Infrastructure

This repository contains Terraform configuration for deploying AWS infrastructure locally using LocalStack. It creates a complete VPC setup with EC2 instance, IAM roles, and S3 bucket for development and testing purposes.

## Overview

This Terraform configuration provisions the following AWS resources in LocalStack:

- **VPC** with CIDR block `10.0.0.0/16`
- **Subnet** with CIDR block `10.0.1.0/24` in availability zone `us-east-1a`
- **Security Group** allowing SSH access on port 22
- **IAM Role** with S3 read-only access for EC2 instances
- **IAM Instance Profile** for EC2 role assumption
- **EC2 Instance** (t2.micro) with the IAM instance profile attached
- **S3 Bucket** named `localstack-bucket`

## Prerequisites

Before using this configuration, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) (>= 0.12)
- [LocalStack](https://docs.localstack.cloud/getting-started/installation/)
- [tflocal](https://github.com/localstack/terraform-local) - Terraform wrapper for LocalStack
- [AWS CLI](https://aws.amazon.com/cli/) (optional, for testing)

## Setup

### 1. Start LocalStack

Start LocalStack with the required services:

```bash
localstack start
```

Or using Docker:

```bash
docker run --rm -it -p 4566:4566 localstack/localstack
```

### 2. Install tflocal

Install the Terraform LocalStack wrapper:

```bash
pip install terraform-local
```

### 3. Initialize Terraform

Initialize the Terraform working directory:

```bash
tflocal init
```

## Usage

### Deploy Infrastructure

To deploy the infrastructure:

```bash
tflocal plan
tflocal apply
```

When prompted, type `yes` to confirm the deployment.

### Verify Deployment

After successful deployment, you can verify the resources using AWS CLI with LocalStack endpoint:

```bash
# List EC2 instances
aws --endpoint-url=http://localhost:4566 ec2 describe-instances

# List S3 buckets
aws --endpoint-url=http://localhost:4566 s3 ls

# List IAM roles
aws --endpoint-url=http://localhost:4566 iam list-roles
```

### Test IAM Role Assumption

You can test the IAM role assumption functionality:

```bash
aws --endpoint-url=http://localhost:4566 sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/localstack-ec2-role \
  --role-session-name test-session
```

### Destroy Infrastructure

To clean up and destroy all resources:

```bash
tflocal destroy
```

## Configuration Details

### Provider Configuration

The AWS provider is configured to work with LocalStack:

- **Region**: `us-east-1`
- **Credentials**: Test credentials (`test`/`test`)
- **Endpoints**: All services point to `http://localhost:4566`
- **Validation**: Skipped for LocalStack compatibility

### Security Configuration

- **VPC**: Isolated network environment
- **Security Group**: Allows SSH (port 22) from anywhere (0.0.0.0/0)
- **IAM Role**: EC2 instances have read-only access to S3

### Resource Tags

All resources are tagged with descriptive names prefixed with `localstack-` for easy identification.

## Important Notes

1. **AMI ID**: The EC2 instance uses AMI `ami-0c55b159cbfafe1f0`. This is a placeholder and may need to be updated based on your LocalStack version.

2. **Security**: This configuration is for development/testing only. The security group allows SSH access from anywhere, which is not recommended for production environments.

3. **LocalStack Limitations**: Some AWS features may have limitations in LocalStack compared to actual AWS services.

## Troubleshooting

### Common Issues

1. **LocalStack not running**: Ensure LocalStack is started and accessible on port 4566
2. **tflocal command not found**: Install terraform-local using `pip install terraform-local`
3. **AMI not found**: Update the AMI ID in the EC2 instance resource if needed

### Logs

Check LocalStack logs for any service-specific issues:

```bash
localstack logs
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with LocalStack
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Additional Resources

- [LocalStack Documentation](https://docs.localstack.cloud/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [tflocal GitHub Repository](https://github.com/localstack/terraform-local)
