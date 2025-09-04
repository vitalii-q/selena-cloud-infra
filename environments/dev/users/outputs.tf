output "users_service_alb_dns" {
  value = aws_lb.users_service_alb.dns_name
}

output "users_alb_sg_id" {
  value = aws_security_group.users_alb_sg.id
}

output "users_asg_name" {
  value = aws_autoscaling_group.users_service_asg.name
}
