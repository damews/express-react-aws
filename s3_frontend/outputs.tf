output "website-url" {
	description = "S3 Website URL"
  value 			= aws_s3_bucket_website_configuration.bucket_website_configuration.website_endpoint
}

output "cdn-url" {
	description = "CDN Website URL"
	value 			=	aws_cloudfront_distribution.s3_distribution.domain_name
}