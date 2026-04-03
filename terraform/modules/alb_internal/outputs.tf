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
  value       = aws_security_group.internal_alb_sg.id
}