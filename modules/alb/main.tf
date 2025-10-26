# Create Application Load Balancer
resource "aws_lb" "users_alb" {
  name            = var.name
  internal        = false
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  subnets         = var.subnets

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name        = var.name
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "users_tg" {
  name     = "${var.name}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.name}-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "users_http_listener" {
  load_balancer_arn = aws_lb.users_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users_tg.arn
  }

  depends_on = [aws_lb.users_alb, aws_lb_target_group.users_tg] # guarantee that Listener is created after ALB and Target Group
}
