terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
    
    required_version = ">= 0.12"
}

#Configure the AWS provider pointing to Localstack endpoint
provider "aws" {
    region                      = "us-east-1"
    access_key                  = "test"
    secret_key                  = "test"
    skip_credentials_validation = true
    skip_metadata_api_check     = true      
    skip_requesting_account_id  = true
    endpoints {
        s3 = "http://localhost:4566"
        iam = "http://localhost:4566"
        ec2 = "http://localhost:4566"
    }
}

# Create the VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "localstack-vpc"
    }
}

# Create the Subnet
resource "aws_subnet" "main" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "localstack-subnet"
    }
}

# Create Security Group allowing SSH 
resource "aws_security_group" "main" {
    vpc_id = aws_vpc.main.id
    name   = "localstack-sg"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# IAM Role for EC2 instance 
resource "aws_iam_role" "ec2_role" {
    name = "localstack-ec2-role"

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

# IAM Role Policy Attachment (for example, S3 read access) 
resource "aws_iam_role_policy_attachment" "ec2_s3_read" {
    role       = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Istance Profile for EC2 to assume the role
resource "aws_iam_instance_profile" "ec2_profile" {
    name = "localstack-ec2-profile"
    role = aws_iam_role.ec2_role.name
} 

# EC2 Instance (using Amazon Linux 2 AMI)
resource "aws_instance" "web_server" {
    ami = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID for your region
    instance_type = "t2.micro"
    subnet_id = aws_subnet.main.id
    vpc_security_group_ids = [aws_security_group.main.id]
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

    tags = {
        Name = "localstack-web-server"
    }
}

# S3 Bucket for Localstack
resource "aws_s3_bucket" "localstack_bucket" {
    bucket = "localstack-bucket"
}
