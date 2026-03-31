output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "https_listener_arn" {
  value = aws_lb_listener.https_listener.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}