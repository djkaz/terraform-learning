#creating an ec2 instance simple
terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}


provider "aws" {
    region = "us-east-1"
    access_key =  "test"
    secret_key = "test"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    endpoints {
        ec2 = "http://localhost:4566"
    }
}

resource "aws_instance" "smechera" {
    ami           = "ami-12345678"
    instance_type = "t2.micro"
    tags = {
        Name = "smechera"
    }  
}
