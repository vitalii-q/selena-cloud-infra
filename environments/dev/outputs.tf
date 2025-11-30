output "users_service_ecr_uri" {
  value = module.users.users_service_ecr_uri
}

# Users RDS endpoint output
output "users_rds_endpoint" {
  value = module.users.users_rds_endpoint
}

# Export the Hosted Zone ID
output "users_service_route53_zone_id" {
  value = data.aws_route53_zone.main_zone.zone_id
}

# AWS_ACCESS_KEY_ID
output "github_actions_access_key_id" {
  value = module.users.github_actions_access_key_id
}

# AWS_SECRET_ACCESS_KEY
output "github_actions_secret_access_key" {
  value     = module.users.github_actions_secret_access_key
  sensitive = true
}
