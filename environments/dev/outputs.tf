output "users_service_ecr_uri" {
  value = module.users.users_service_ecr_uri
}

# Users RDS endpoint output
output "users_rds_endpoint" {
  value = module.users.users_rds_endpoint
}
