output "selena_ec2_profile_name" {
  value = aws_iam_instance_profile.selena_ec2_instance_profile.name
}

output "selena_ec2_role_name" {
  value = aws_iam_role.selena_ec2_role.name
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

# AWS_ACCESS_KEY_ID for ci/cd access
output "github_actions_access_key_id" {
  value = aws_iam_access_key.github_actions_key.id
}

# AWS_SECRET_ACCESS_KEY for ci/cd access
output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions_key.secret
  sensitive = true
}
