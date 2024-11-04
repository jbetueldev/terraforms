####################################################
# Deploy a Cloudformation dist for S3 static website
####################################################
module "cf_s3_deploy" {
  source      = "./modules/cf-s3-deploy"
  bucket_name = var.bucket_name
  s3_objects  = var.s3_objects
  environment = var.environment
  location    = var.location
  app         = var.app
  domain      = var.domain
  alias       = var.alias
}