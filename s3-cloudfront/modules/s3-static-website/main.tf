####################################################
# S3 static website bucket
####################################################
resource "aws_s3_bucket" "s3_static_website" {
  bucket = "${var.environment}-${var.location}-${var.bucket_name}"
  tags = {
    Name = "${var.environment}-${var.location}-${var.bucket_name}"
    Environment = var.environment
    Location = var.location
    Application = var.app
    Domain = var.domain
  }
}

####################################################
# S3 public access settings
####################################################
resource "aws_s3_bucket_public_access_block" "static_site_bucket_public_access" {
  bucket = aws_s3_bucket.s3_static_website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

####################################################
# Create initial folders inside the bucket
####################################################
resource "aws_s3_object" "initial_folders" {
  bucket = aws_s3_bucket.s3_static_website.id
  key    = element(var.s3_objects, count.index)
  count  = length(var.s3_objects)
}

####################################################
# Enable bucket versioning
####################################################
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_static_website.id
  versioning_configuration {
    status = "Enabled"
  }
}