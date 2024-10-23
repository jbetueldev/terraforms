resource "aws_lb" "dev_london_metabase_alb" {
  name               = "dev-london-metabase-alb"
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [aws_security_group.dev_london_metabase_ecs_sg.id]
}

resource "aws_lb_target_group" "dev_london_metabase_tg" {
  name        = "dev-london-metabase-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "dev_london_metabase_tg_listener_http" {
  load_balancer_arn = aws_lb.dev_london_metabase_alb.arn
  depends_on        = [aws_lb.dev_london_metabase_alb]
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.dev_london_metabase_tg.id
    type             = "forward"
  }
}

# resource "aws_lb_listener" "dev_london_metabase_tg_listener_https" {
#     load_balancer_arn = aws_lb.dev_london_metabase_alb.id
#     port              = 443
#     protocol          = "HTTPS"
#     ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#     certificate_arn   = "arn:aws:acm:eu-west-2:597910921229:certificate/85bf4353-d056-4ee5-9db8-bf9323b631ba"

#     default_action {
#         target_group_arn = aws_lb_target_group.dev_london_metabase_tg.id
#         type             = "forward"
#     }
# }