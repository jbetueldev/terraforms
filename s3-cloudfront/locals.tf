locals {
  common_tags = {
    Application = var.app
    Domain      = var.domain
    Environment = var.environment
    Location    = var.location
  }
}

