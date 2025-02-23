terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "for_terraform_testing" {
  ami = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"
}