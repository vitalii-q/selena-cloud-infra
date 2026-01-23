output "alb_arn" {
  value = aws_lb.service_alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.service_tg.arn
}

output "alb_dns_name" {
  value       = aws_lb.service_alb.dns_name
  description = "Public DNS name of the Application Load Balancer"
}

output "alb_tg_arn" {
  value = aws_lb_target_group.service_tg.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}