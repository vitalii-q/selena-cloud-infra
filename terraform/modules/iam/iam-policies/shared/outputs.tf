output "cloudwatch_metrics_policy_arn" {
  description = "ARN of the CloudWatch Metrics Policy"
  value = aws_iam_policy.cloudwatch_metrics_policy.arn
}

output "ec2_stop_start_policy_arn" {
  description = "ARN of the EC2 Stop/Start Policy"
  value = aws_iam_policy.ec2_stop_start_policy.arn
}

output "ec2_ecr_access_policy_arn" {
  description = "ARN of the ECR Access Policy"
  value = aws_iam_policy.ec2_ecr_access_policy.arn
}
