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

# AWS_ACCESS_KEY_ID
output "github_actions_access_key_id" {
  value = module.iam.github_actions_access_key_id
}

# AWS_SECRET_ACCESS_KEY
output "github_actions_secret_access_key" {
  value     = module.iam.github_actions_secret_access_key
  sensitive = true
}

# AMI(Packer) id
output "ami_id" {
  value = data.aws_ami.selena_base.id
}
