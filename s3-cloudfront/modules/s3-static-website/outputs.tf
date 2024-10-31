output "static_website_id" {
  value = aws_s3_bucket.s3_static_website.id
}

output "static_website_regional_domain_name" {
  value = aws_s3_bucket.s3_static_website.bucket_regional_domain_name
}

output "static_website_arn" {
  value = aws_s3_bucket.s3_static_website.arn
}