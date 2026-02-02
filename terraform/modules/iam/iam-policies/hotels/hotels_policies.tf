# --- Secrets Manager (hotels DB) ---
resource "aws_iam_policy" "ec2_secrets_access_policy" {
  name        = "HotelsDBSecretsAccessPolicy"
  description = "Allow EC2 to read users-service secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          ],
        Resource = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:selena-hotels-db*"
      }
    ]
  })
}