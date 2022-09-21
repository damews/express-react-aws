locals {
  website_bucket_name = "${var.default_app_name}-${terraform.workspace}-frontend-${data.aws_caller_identity.current.account_id}"
  logs_bucket_name = "${var.default_app_name}-${terraform.workspace}-frontend-logs-${data.aws_caller_identity.current.account_id}"
  cloudfront_name = "${var.default_app_name}-${terraform.workspace}-cloudfront-${data.aws_caller_identity.current.account_id}"

  common_tags = {
    Application = "${var.default_app_name}"
  }
}

