output "s3_bucket_name" {
  value = module.cf_s3_deploy.s3_bucket_name
}

output "cloudfront_domain_name" {
  value = "http://${module.cf_s3_deploy.cloudfront_domain_name}"
}

output "alternate_domain_name" {
  value = "http://${var.alias}"
}