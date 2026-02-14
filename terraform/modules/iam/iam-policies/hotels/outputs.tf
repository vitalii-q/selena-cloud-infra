output "ec2_secrets_access_policy_arn" {
  value = aws_iam_policy.ec2_secrets_access_policy.arn
}

# Output for Hotels DB (CockroachDB) SSM policy ARN
output "hotels_db_ssm_policy_arn" {
  value = aws_iam_policy.hotels_db_ssm_policy.arn
}
