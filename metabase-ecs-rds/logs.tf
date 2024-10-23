resource "aws_cloudwatch_log_group" "dev_london_metabase_log_group" {
  name              = "/ecs/dev-london-metabase-taskdef"
  retention_in_days = 0 # Never expire
}

resource "aws_cloudwatch_log_stream" "dev_london_metabase_log_stream" {
  name           = "dev-london-metabase-log-stream"
  log_group_name = aws_cloudwatch_log_group.dev_london_metabase_log_group.name
}