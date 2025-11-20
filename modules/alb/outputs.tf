output "alb_arn" {
  value = aws_lb.users_alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.users_tg.arn
}

output "users_alb_dns_name" {
  value       = aws_lb.users_alb.dns_name
  description = "Public DNS name of the Application Load Balancer"
}

output "users_tg_arn" {
  value = aws_lb_target_group.users_tg.arn
}