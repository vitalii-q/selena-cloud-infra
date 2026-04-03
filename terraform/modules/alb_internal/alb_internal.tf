# Internal Application Load Balancer
resource "aws_lb" "internal_alb" {
  name               = "${var.environment}-${var.service_name}-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnets
  security_groups    = [aws_security_group.internal_alb_sg.id]

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name        = "${var.service_name}-alb"
    Environment = var.environment
  }
}

# Security Group for internal ALB
resource "aws_security_group" "internal_alb_sg" {
  name        = "${var.service_name}-alb-sg"
  vpc_id      = var.vpc_id
  description = "Internal ALB for microservices communication"

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description     = "Allow traffic from microservices"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }
}

# Target Group for Users Service
resource "aws_lb_target_group" "users_tg" {
  name     = "users-tg-internal" 
  port     = 9065  
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# Target Group for Hotels Service
resource "aws_lb_target_group" "hotels_tg" {
  name     = "hotels-tg-internal"
  port     = 9064
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
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

# Listener rule for Users service
resource "aws_lb_listener_rule" "users_rule" {
  listener_arn = aws_lb_listener.internal_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users_tg.arn
  }

  condition {
    path_pattern {
      values = ["/users*"]
    }
  }
}

# Listener rule for Hotels service
resource "aws_lb_listener_rule" "hotels_rule" {
  listener_arn = aws_lb_listener.internal_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hotels_tg.arn
  }

  condition {
    path_pattern {
      values = ["/hotels*"]
    }
  }
}