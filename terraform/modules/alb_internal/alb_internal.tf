# Internal Application Load Balancer
resource "aws_lb" "internal_alb" {
  name               = "${var.environment}-${var.service_name}"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnets
  security_groups    = [aws_security_group.internal_alb_sg.id]

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name        = "${var.service_name}"
    Environment = var.environment
  }
}