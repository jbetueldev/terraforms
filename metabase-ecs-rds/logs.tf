resource "aws_cloudwatch_log_group" "metabase_log_group" {
  name              = "/ecs/${var.environment}-${var.location}-metabase-taskdef"
  retention_in_days = 0 # Never expire
}

resource "aws_cloudwatch_log_stream" "metabase_log_stream" {
  name           = "${var.environment}-${var.location}-metabase-log-stream"
  log_group_name = aws_cloudwatch_log_group.metabase_log_group.name
}