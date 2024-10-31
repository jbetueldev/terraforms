####################################################
# Create S3 Static Website
####################################################
module "s3_website" {
  source        = "./modules/s3-static-website"
  bucket_name   = var.bucket_name
  environment = var.environment
  location = var.location
  s3_objects = var.s3_objects
  common_tags   = local.common_tags
}

####################################################
# Create AWS Cloudfront distribution
####################################################
module "cloud_front" {
  source        = "./modules/cloud-front"
  bucket_id  = module.s3_website.static_website_id
  bucket_regional_domain = module.s3_website.static_website_regional_domain_name
  common_tags   = local.common_tags
}

####################################################
# S3 bucket policy to allow access from cloudfront
####################################################
module "s3_cf_policy_primary" {
  source                      = "./modules/s3-cf-policy"
  bucket_id                   = module.s3_website.static_website_id
  bucket_arn                  = module.s3_website.static_website_arn
  cloudfront_distribution_arn = module.cloud_front.cloudfront_distribution_arn
}

