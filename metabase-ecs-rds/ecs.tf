resource "aws_ecs_cluster" "dev_london_metabase_cluster" {
  name = "dev-london-metabase-cluster"
}

resource "aws_ecs_task_definition" "dev_london_metabase_taskdef" {
  family                   = "dev-london-metabase-taskdef"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.dev_london_metabase_role.arn  # "arn:aws:iam::022499043217:role/ecsTaskExecutionRole"
  container_definitions = templatefile("task-definitions/dev-london-metabase-taskdef.tpl.json", {
    app_image = var.app_image, 
    app_port  = var.app_port,
    rds_host = "${aws_rds_cluster.dev_london_general_purpose_rds.endpoint}",
    app_url = "${aws_lb.dev_london_metabase_alb.dns_name}",    # "https://metabase-test.spinbet.com"
    secret_arn = "${aws_rds_cluster.dev_london_general_purpose_rds.master_user_secret[0].secret_arn}",
    aws_region = var.aws_region
    })
}

resource "aws_ecs_service" "dev_london_metabase_svc" {
  name                 = "dev-london-metabase-svc"
  cluster              = aws_ecs_cluster.dev_london_metabase_cluster.id
  task_definition      = aws_ecs_task_definition.dev_london_metabase_taskdef.arn
  desired_count        = var.app_count
  launch_type          = "FARGATE"
  force_new_deployment = true

  network_configuration {
    security_groups  = [aws_security_group.dev_london_metabase_ecs_sg.id]
    subnets          = var.subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.dev_london_metabase_tg.id
    container_name   = "metabase"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.dev_london_metabase_tg_listener_http]
}

resource "aws_iam_role" "dev_london_metabase_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs.json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "ecs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.dev_london_metabase_role.name
}

resource "aws_iam_role_policy_attachment" "secrets" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.dev_london_metabase_role.name
}