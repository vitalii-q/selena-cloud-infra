output "alb_arn" {
  value = aws_lb.users_alb.arn
}

output "alb_dns_name" {
  value = aws_lb.users_alb.dns_name
}
