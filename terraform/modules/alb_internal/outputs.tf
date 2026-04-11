output "alb_dns_name" {
  description = "DNS name of internal ALB"
  value       = aws_lb.internal_alb.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of internal ALB"
  value       = aws_lb.internal_alb.zone_id
}

output "internal_alb_sg_id" {
  description = "Security group of internal ALB"
  value       = module.internal_alb_sg.id
}

output "users_target_group_arn" {
  value = aws_lb_target_group.users_tg.arn
}

output "hotels_target_group_arn" {
  value = aws_lb_target_group.hotels_tg.arn
}