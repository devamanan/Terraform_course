terraform {
  ############################################################
  # AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  # YOU WILL UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
  # TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  ############################################################
    backend "s3" {
      bucket         = "my-terraform-state-bucket-2025-devdevops" # REPLACE WITH YOUR BUCKET NAME
      key            = "03-basics/import-bootstrap/terraform.tfstate"
      region         = "us-east-1"
      dynamodb_table = "terraform-state-locking-2025-devdevops"
      encrypt        = true
    }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {


  
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state_2025" {
  bucket        = "my-terraform-state-bucket-2025-devdevops" # REPLACE WITH YOUR BUCKET NAME
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_2025.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket = aws_s3_bucket.terraform_state_2025.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking-2025-devdevops"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}