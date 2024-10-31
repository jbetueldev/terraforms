output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "alb_hostname" {
  value = aws_lb.metabase_alb.dns_name
}