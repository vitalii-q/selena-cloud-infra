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