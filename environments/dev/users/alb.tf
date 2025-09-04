# Target Group для users-service
resource "aws_lb_target_group" "users_service_tg" {
  name        = "users-service-tg"
  port        = var.users_service_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  health_check {
    path                = var.users_service_health_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "users-service-tg"
  }
}

# ALB для users-service
resource "aws_lb" "users_service_alb" {
  name               = "users-service-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.users_alb_sg.id]
  subnets            = [module.vpc.public_subnet_id]

  tags = {
    Name = "users-service-alb"
  }
}

# Listener для ALB
resource "aws_lb_listener" "users_service_listener" {
  load_balancer_arn = aws_lb.users_service_alb.arn
  port              = var.users_service_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users_service_tg.arn
  }
}

resource "aws_security_group" "users_alb_sg" {
  name   = "users-alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "users-alb-sg"
  }
}

