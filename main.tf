terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}

# Create a VPC
resource "aws_vpc" "ChatApp-VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ChatApp-VPC"
  }
}