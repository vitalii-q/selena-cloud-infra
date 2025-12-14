# --- CloudWatch Role ---
resource "aws_iam_role" "cloudwatch_agent_server_role" {
  name = "cloudwatch-agent-server-role"

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

    tags = {
    Project = "Selena"
    Service = "users-service"
  }
}

# --- Instance Profile for cloudwatch_agent_server_role ---
resource "aws_iam_instance_profile" "cloudwatch_agent_instance_profile" {
  name = "CloudWatchAgentInstanceProfile"
  role = aws_iam_role.cloudwatch_agent_server_role.name
}