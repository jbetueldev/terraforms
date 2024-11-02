# data "aws_acm_certificate" "razed_certificate" {
#   domain = "razed.com"
#   most_recent = true
#   statuses = ["ISSUED"]
# }

####################################################
# Create AWS Cloudfront distribution
####################################################
resource "aws_cloudfront_origin_access_control" "cf-s3-oac" {
  name                              = "CloudFront S3 OAC"
  description                       = "CloudFront S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cf-dist" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = var.bucket_regional_domain
    origin_id                = "${var.bucket_id}-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.cf-s3-oac.id
  }

  comment = "${var.alias} distribution"

  # aliases = [var.alias]

  default_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = "${var.bucket_id}-origin"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    # acm_certificate_arn = data.aws_acm_certificate.existing_certificate.arn
    # ssl_support_method  = "sni-only"
  }

  tags = merge(var.common_tags, {
    Name = "${var.bucket_id}-cloudfront"
  })
}
