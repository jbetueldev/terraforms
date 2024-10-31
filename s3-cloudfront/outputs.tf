output "s3_bucket_name" {
  value = module.s3_website.static_website_id
}

output "cloudfront_domain_name" {
  value = "http://${module.cloud_front.cloudfront_distribution_domain_name}"
}

output "alternate_domain_name" {
  value = "http://${var.alias}"
}