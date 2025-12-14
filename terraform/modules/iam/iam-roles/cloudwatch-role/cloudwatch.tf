# --- CloudWatch Role ---
resource "aws_iam_role" "cloudwatch_agent_server_role" {
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

    tags = {
    Project = "Selena"
    Service = "users-service"
  }
}

# --- Instance Profile for cloudwatch_agent_server_role ---
resource "aws_iam_instance_profile" "cloudwatch_agent_instance_profile" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.cloudwatch_agent_server_role.name
}

resource "aws_iam_role_policy_attachment" "attach" {
  for_each   = var.policies
  role       = aws_iam_role.cloudwatch_agent_server_role.name
  policy_arn = each.value
}