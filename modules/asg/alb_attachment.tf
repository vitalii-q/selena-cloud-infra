# Attach ASG to Target Group ALB
resource "aws_autoscaling_attachment" "asg_to_tg" {
  autoscaling_group_name = aws_autoscaling_group.this.name
  lb_target_group_arn    = var.users_alb_tg_arn
}
