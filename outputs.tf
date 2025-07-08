# outputs are available to the root (calling) module
output "bucket_arn" {
  description = "ARN of the s3 bucket"
  value       = aws_s3_bucket.s3_bucket.arn
}

output "bucket_name" {
  description = "The name of the s3 bucket"
  value       = aws_s3_bucket.s3_bucket.id
}

output "bucket_domain" {
  description = "The s3 bucket website domain name"
  value       = aws_s3_bucket_website_configuration.s3_bucket.website_domain
}

output "bucket_tags" {
  description = "The tags applied to the S3 bucket"
  value       = aws_s3_bucket.s3_bucket.tags_all
}

output "website_endpoint" {
  description = "The URL endpoint for the website"
  value       = aws_s3_bucket_website_configuration.s3_bucket.website_endpoint
}


