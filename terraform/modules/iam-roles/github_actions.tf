# IAM user for GitHub Actions (CI/CD)
resource "aws_iam_user" "github_actions" {
  name = "github-actions-user"
}

# Create AWS access keys for GitHub Actions
resource "aws_iam_access_key" "github_actions_key" {
  user = aws_iam_user.github_actions.name
}
