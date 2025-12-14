# AWS_ACCESS_KEY_ID for ci/cd access
output "github_actions_access_key_id" {
  value = aws_iam_access_key.github_actions_key.id
}

# AWS_SECRET_ACCESS_KEY for ci/cd access
output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions_key.secret
  sensitive = true
}

output "selena_users_ec2_profile_name" {
  description = "IAM instance profile name"
  value       = aws_iam_instance_profile.this.name
}