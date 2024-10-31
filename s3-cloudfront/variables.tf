variable "aws_access_key" {
  description = "IAM public access key"
}

variable "aws_secret_key" {
  description = "IAM secret access key"
}

variable "aws_region" {
  description = "AWS region to use for resources."
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 Bucket"
  default     = "h0us3-g4m3s-fr0nt3nd"
}

variable "s3_objects" {
  type        = list(string)
  description = "Initial Folders inside S3 Bucket"
  default = ["dice/commits/",
    "keno/commits/",
    "mines/commits/",
    "limbo/commits/",
    "plinko/commits/"
  ]
}

variable "app" {
  type        = string
  description = "Application name for resource tagging"
  default     = "house games"
}

variable "domain" {
  type        = string
  description = "Domain name for resource tagging"
  default     = "razed"
}

variable "environment" {
  type        = string
  description = "Environment for deployment"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Location for deployment"
  default     = "london"
}

variable "alias" {
  type        = string
  description = "Alternate domain in Cloudfront Distribution"
  default     = "house-games-dev.razed.com"
}