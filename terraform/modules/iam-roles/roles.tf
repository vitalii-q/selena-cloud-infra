# --- EC2 Role & Instance Profile ---
resource "aws_iam_role" "this" {
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

# --- Instance Profile for aws_iam_role.this ---
resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.this.name
}

# --- Role for EC2 ---
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
