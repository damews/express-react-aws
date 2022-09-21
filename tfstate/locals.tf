locals {
  default_name        = "tfstate-${data.aws_caller_identity.current.account_id}"
  bucket_name         = "${local.default_name}-terraform-state"
  dynamodb_table_name = "${local.default_name}-terraform-lock"
}