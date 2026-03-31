resource "aws_lb_target_group" "service_tg" {
  name = "${var.service_name}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path                = var.health_check
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2

    matcher = "200-399"
  }

  tags = {
    Name        = "${var.service_name}-tg"
    Environment = var.environment
  }
}


resource "aws_lb_listener_rule" "service_rule" {
  listener_arn = var.listener_arn
  priority = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tg.arn
  }

  condition {
    host_header {
      values = [var.path_pattern]
    }
  }
}