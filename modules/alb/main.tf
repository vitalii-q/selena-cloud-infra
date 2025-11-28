# Create Application Load Balancer
resource "aws_lb" "users_alb" {
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

# For EC2 instances
/*resource "aws_lb_target_group_attachment" "users_ec2_attachment" {
  target_group_arn = aws_lb_target_group.users_tg.arn
  target_id        = var.ec2_instance_id
  port             = var.target_port
}*/

# For ASG EC2 instances
/*resource "aws_autoscaling_attachment" "asg_to_tg" {
  autoscaling_group_name = var.users_asg_name  # ASG name
  lb_target_group_arn    = aws_lb_target_group.users_tg.arn
}*/

resource "aws_security_group" "alb_sg" {
  name        = "users-alb-sg"
  description = "Security group for users-service ALB"
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
    Name        = "users-alb-sg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "users_https_listener" {
  load_balancer_arn = aws_lb.users_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users_tg.arn
  }

  depends_on = [
    aws_lb.users_alb,
    aws_lb_target_group.users_tg
  ]
}
