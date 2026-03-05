output "users_asg_name" {
  value = try(module.users_asg[0].asg_name, null)
}

output "users_service_ecr_uri" {
  value = module.ecr.services_ecr_uri
}

# Users RDS endpoint output
output "users_rds_endpoint" {
  value       = try(module.users_rds[0].users_postgres_endpoint, null)
  description = "Endpoint of Users Service RDS"
}

output "users_alb_dns_name" {
  value       = try(module.users_alb[0].alb_dns_name, null)
  description = "DNS name of Users Service ALB"
}
