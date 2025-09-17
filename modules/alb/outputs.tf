output "alb_dns_name" {
  description = "DNS ALB"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "ARN Target Group for ECS"
  value       = aws_lb_target_group.this.arn
}
