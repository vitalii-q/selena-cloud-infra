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

