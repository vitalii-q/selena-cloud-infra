output "alb_tg_arn" {
  description = "Target group ARN for the service"
  value       = aws_lb_target_group.service_tg.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = var.listener_arn != null ? "ALB exists" : null
}