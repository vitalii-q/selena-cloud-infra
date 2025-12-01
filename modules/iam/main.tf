# Creating an instance profile for EC2
resource "aws_iam_instance_profile" "selena_ec2_instance_profile" {
  name = "selena-ec2-instance-profile"
  role = aws_iam_role.selena_ec2_role.name
}

resource "aws_iam_policy" "ec2_stop_start_policy" {
  name        = "Ec2StopStartPolicy"
  description = "Policy to allow stopping and starting EC2 instances"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:StopInstances",
          "ec2:StartInstances",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_s3_access_policy" {
  name        = "ec2-s3-access-policy"
  description = "Allow EC2 to access selena-users-service-env-dev S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::selena-users-service-env-dev",
          "arn:aws:s3:::selena-users-service-env-dev/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "selena_ec2_role" {
  name = "selena-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_rds_read" {
  name        = "EC2RDSReadPolicy"
  description = "Allow EC2 to describe RDS instances"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "rds:DescribeDBInstances"
        ],
        Resource = "*"
      }
    ]
  })
}

# IAM role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM role for ECS Task (application permissions)
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_secrets_access_policy" {
  name        = "EC2SecretsAccessPolicy"
  description = "Allow EC2 to read users-service secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:selena-users-db-dev*"
      }
    ]
  })
}
