output "rds_endpoint" {
  value = aws_rds_cluster.general_purpose_rds.endpoint
}

output "rds_secret_arn" {
  value = aws_rds_cluster.general_purpose_rds.master_user_secret[0].secret_arn
}

