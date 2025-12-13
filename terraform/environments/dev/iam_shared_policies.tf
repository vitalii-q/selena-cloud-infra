# --- EC2 Policies ---
resource "aws_iam_policy" "ec2_stop_start_policy" {     # TODO: bind to a specific user to execute console commands
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

# --- CloudWatch Policies ---
resource "aws_iam_policy" "cloudwatch_metrics_policy" {
  name        = "SelenaEC2CloudWatchMetricsPolicy"
  description = "Allow EC2 instances to send and list CloudWatch metrics"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics"
        ]
        Resource = "*"
      }
    ]
  })
}

# --- GitHub Actions Policy ---
resource "aws_iam_policy" "github_actions_ecr_policy" {
  name        = "GitHubActionsECRPolicy"
  description = "Allow GitHub Actions to push to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}