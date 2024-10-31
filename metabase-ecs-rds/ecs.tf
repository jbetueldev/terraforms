# Create AWS RDS ##############
module "rds" {
  source          = "./modules/rds"
  vpc_rds         = var.vpc
  vpc_cidr_rds    = var.vpc_cidr
  subnets_rds     = var.subnets
  azs_rds         = var.azs
  environment_rds = var.environment
  location_rds    = var.location
}
###############################

resource "aws_ecs_cluster" "metabase_cluster" {
  name = "${var.environment}-${var.location}-metabase-cluster"
}

resource "aws_ecs_task_definition" "metabase_taskdef" {
  family                   = "${var.environment}-${var.location}-metabase-taskdef"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.metabase_role.arn # "arn:aws:iam::022499043217:role/ecsTaskExecutionRole"
  container_definitions = templatefile("task-definitions/metabase-taskdef.tpl.json", {
    app_image   = var.app_image,
    app_port    = var.app_port,
    rds_host    = "${module.rds.rds_endpoint}",
    app_url     = "${aws_lb.metabase_alb.dns_name}", # var.app_url
    secret_arn  = "${module.rds.rds_secret_arn}",
    aws_region  = var.aws_region,
    environment = var.environment,
    location    = var.location
  })
}

resource "aws_ecs_service" "metabase_svc" {
  name                 = "${var.environment}-${var.location}-metabase-svc"
  cluster              = aws_ecs_cluster.metabase_cluster.id
  task_definition      = aws_ecs_task_definition.metabase_taskdef.arn
  desired_count        = var.app_count
  launch_type          = "FARGATE"
  force_new_deployment = true

  network_configuration {
    security_groups  = [aws_security_group.metabase_ecs_sg.id]
    subnets          = var.subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.metabase_tg.id
    container_name   = "metabase"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.metabase_tg_listener_http]
}

resource "aws_iam_role" "metabase_role" {
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
  role       = aws_iam_role.metabase_role.name
}

resource "aws_iam_role_policy_attachment" "secrets" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.metabase_role.name
}