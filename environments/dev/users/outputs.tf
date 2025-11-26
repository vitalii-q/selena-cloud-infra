output "users_asg_name" {
  value = module.users_asg.asg_name
}

output "users_service_ecr_uri" {
  value = module.ecr.users_service_ecr_uri
}

# Users RDS endpoint output
output "users_rds_endpoint" {
  description = "RDS endpoint for Users Service database"
  value       = module.users_rds.endpoint
}

output "users_alb_dns_name" {
  value = module.users_alb.users_alb_dns_name
}
