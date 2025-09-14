resource "aws_iam_user_policy_attachment" "attach_ec2_policy" {
  user       = var.user_name
  policy_arn = aws_iam_policy.ec2_stop_start_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ec2_s3_access" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = aws_iam_policy.ec2_s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.selena_ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "selena_ec2_cloudwatch_attach" {
  role       = aws_iam_role.selena_ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_metrics_policy.arn
}

# Tie the CloudWatch managed policy to our EC2 role
resource "aws_iam_role_policy_attachment" "selena_ec2_cloudwatch" {
  role       = aws_iam_role.selena_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "attach_ec2_rds_read" {
  role       = aws_iam_role.selena_ec2_role.name
  policy_arn = aws_iam_policy.ec2_rds_read.arn
}

# Attach AmazonECSTaskExecutionRolePolicy (AWS managed policy)
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM role EC2 for ECS
resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach" {
  role       = aws_iam_role.selena_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}