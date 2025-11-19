output "users_service_ecr_uri" {
  value = module.users.users_service_ecr_uri
}

output "users_alb_dns_name" {
  value = module.users.users_alb_dns_name
}

# Users RDS endpoint output
output "users_rds_endpoint" {
  value = module.users.users_rds_endpoint
}