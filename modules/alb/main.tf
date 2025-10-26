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