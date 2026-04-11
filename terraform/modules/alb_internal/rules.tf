# Rule for Users service
resource "aws_lb_listener_rule" "users_rule" {
  listener_arn = aws_lb_listener.internal_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users_tg.arn
  }

  condition {
    host_header {
      values = ["users.internal.selena"]
    }
  }
}

# Rule for Hotels service
resource "aws_lb_listener_rule" "hotels_rule" {
  listener_arn = aws_lb_listener.internal_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hotels_tg.arn
  }

  condition {
    host_header {
      values = ["hotels.internal.selena"]
    }
  }
}