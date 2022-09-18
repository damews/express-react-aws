resource "aws_s3_bucket" "website" {
  bucket        = "${local.app_name_default}-website-${terraform.workspace}-${data.aws_caller_identity.current.account_id}"
  
  force_destroy = false

  tags = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "website_s3_public_access" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "acl_website" {
  bucket = aws_s3_bucket.website.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "bucket_website_configuration" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}


resource "aws_s3_bucket" "logs" {
  bucket        = "${local.app_name_default}-logs-${terraform.workspace}-${data.aws_caller_identity.current.account_id}"
  force_destroy = false

  tags = local.common_tags

}

resource "aws_s3_bucket_acl" "acl_logs" {
  bucket = aws_s3_bucket.logs.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "website_app_policy" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.s3_allow_access_from_cf.json
}

data "aws_iam_policy_document" "s3_allow_access_from_cf" {
  statement {
    sid = "PublicReadForGetBucketObjects"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.cf_identity.id}"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.website.arn,
      "${aws_s3_bucket.website.arn}/*",
    ]
  }
}