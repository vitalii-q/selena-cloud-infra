# --- GitHub Actions Role ---
resource "aws_iam_role" "github_actions_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = var.service
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.github_actions_role.name
}

# --- Attach policies dynamically ---
resource "aws_iam_role_policy_attachment" "attach" {
  for_each   = var.policies
  role       = aws_iam_role.github_actions_role.name
  policy_arn = each.value
}
