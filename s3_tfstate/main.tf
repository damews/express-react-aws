terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.31.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "awspersonal"
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "kms_key_tfstate" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "bucket_tfstate" {
  bucket = "cipp-terraform-state-${data.aws_caller_identity.current.account_id}"

  force_destroy = false

  tags = {
    component = "cipp"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_ssencryption_tfstate" {
  bucket = aws_s3_bucket.bucket_tfstate.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_key_tfstate.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "bucket_acl_tfstate" {
  bucket = aws_s3_bucket.bucket_tfstate.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_tfstate" {
  bucket = aws_s3_bucket.bucket_tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tfstate_locks" {
  name         = "cipp-terraform-lock-${data.aws_caller_identity.current.account_id}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    component = "cipp"
  }
}