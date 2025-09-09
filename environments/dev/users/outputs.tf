output "users_service_alb_dns" {
  value = aws_lb.users_service_alb.dns_name
}

output "users_alb_sg_id" {
  value = aws_security_group.users_alb_sg.id
}

output "users_asg_name" {
  value = module.users_asg.asg_name
}

output "users_service_ecr_uri" {
  value = module.ecr.users_service_ecr_uri
}
