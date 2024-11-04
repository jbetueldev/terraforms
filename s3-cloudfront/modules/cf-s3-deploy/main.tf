####################################################
# Create S3 Static Website
####################################################
module "s3_website" {
  source      = "../s3-static-website"
  bucket_name = var.bucket_name
  s3_objects  = var.s3_objects
  environment = var.environment
  location    = var.location
  app = var.app
  domain = var.domain
}

####################################################
# Create AWS Cloudfront distribution
####################################################
module "cloud_front" {
  source                 = "../cloud-front"
  bucket_id              = module.s3_website.static_website_id
  bucket_regional_domain = module.s3_website.static_website_regional_domain_name
  alias = var.alias
  environment = var.environment
  location    = var.location
  app = var.app
  domain = var.domain
}

####################################################
# S3 bucket policy to allow access from Cloudfront
####################################################
module "s3_cf_policy" {
  source                      = "../s3-cf-policy"
  bucket_id                   = module.s3_website.static_website_id
  bucket_arn                  = module.s3_website.static_website_arn
  cloudfront_distribution_arn = module.cloud_front.cloudfront_distribution_arn
}

