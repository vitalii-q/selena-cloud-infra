# IAM user for GitHub Actions (CI/CD)
resource "aws_iam_user" "github_actions" {
  name = "github-actions-user"
}

# Allow GitHub Actions user to push images to ECR
resource "aws_iam_user_policy" "github_actions_ecr_policy" {
  name = "github-actions-ecr-policy"
  user = aws_iam_user.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
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
        ],
        Resource = "*"
      }
    ]
  })
}

# Create AWS access keys for GitHub Actions
resource "aws_iam_access_key" "github_actions_key" {
  user = aws_iam_user.github_actions.name
}
