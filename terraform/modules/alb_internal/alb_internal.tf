# Internal Application Load Balancer
resource "aws_lb" "internal_alb" {
  name                       = "${var.environment}-${var.service_name}"
  internal                   = true
  load_balancer_type         = "application"
  subnets                    = var.private_subnets
  security_groups            = [module.internal_alb_sg.id]

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name        = "${var.service_name}"
    Environment = var.environment
  }
}

# Listener for Internal ALB
resource "aws_lb_listener" "internal_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No matching rule"
      status_code  = "404"
    }
  }
}

# Target Groups for internal services
resource "aws_lb_target_group" "services" {
  for_each = var.services

  name     = "${each.key}-tg-internal"
  port     = each.value.port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = each.value.health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Service     = each.key
    Environment = var.environment
  }
}

# Listener rules for internal services
resource "aws_lb_listener_rule" "services" {
  for_each = var.services

  listener_arn = aws_lb_listener.internal_listener.arn
  priority     = 100 + index(keys(var.services), each.key)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services[each.key].arn
  }

  condition {
    host_header {
      values = [each.value.host]
    }
  }
}