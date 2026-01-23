# Create Application Load Balancer
resource "aws_lb" "service_alb" {
  name            = var.name
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.subnets

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name        = var.name
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "service_tg" {
  name     = "${var.name}-tg-${var.target_port}"
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

resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = "Security group for microservice ALB"
  vpc_id      = var.vpc_id

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.alb_sg_name
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.service_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tg.arn
  }

  depends_on = [aws_lb.service_alb, aws_lb_target_group.service_tg] # guarantee that Listener is created after ALB and Target Group
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.service_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tg.arn
  }
}
