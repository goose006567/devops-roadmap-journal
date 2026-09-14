terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"

  s3_use_path_style          = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    s3  = "http://localhost:4566"
    sts = "http://localhost:4566"
    ec2 = "http://localhost:4566"

  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "goose195-day6-bucket"
  tags = {
    Name    = "day6-demo"
    Managed = "terraform"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  tags = {
    Name    = "day6-ec2"
    Managed = "terraform"
  }
}