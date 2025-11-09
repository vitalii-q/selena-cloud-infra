output "users_asg_name" {
  value = module.users_asg.asg_name
}

output "users_service_ecr_uri" {
  value = module.ecr.users_service_ecr_uri
}

output "users_alb_dns_name" {
  value       = module.users_alb.users_alb_dns_name
  description = "Public DNS name of the users-service ALB"
}
