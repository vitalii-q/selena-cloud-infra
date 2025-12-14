output "cloudwatch_metrics_policy_arn" {
  value = aws_iam_policy.cloudwatch_metrics_policy.arn
}

output "ec2_stop_start_policy_arn" {
  value = aws_iam_policy.ec2_stop_start_policy.arn
}

output "github_actions_ecr_policy_arn" {
  value = aws_iam_policy.github_actions_ecr_policy.arn
}