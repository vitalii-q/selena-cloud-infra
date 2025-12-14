output "ec2_s3_access_policy_arn" {
  value = aws_iam_policy.ec2_s3_access_policy.arn
}

output "ec2_secrets_access_policy_arn" {
  value = aws_iam_policy.ec2_secrets_access_policy.arn
}

output "ec2_rds_read_policy_arn" {
  value = aws_iam_policy.ec2_rds_read.arn
}
