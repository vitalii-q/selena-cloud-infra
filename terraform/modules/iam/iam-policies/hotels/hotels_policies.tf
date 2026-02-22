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

# IAM Policy for CockroachDB EC2 to read certs from SSM
resource "aws_iam_policy" "hotels_db_ssm_policy" {
  name        = "HotelsDBSSMPolicy"
  description = "Allow DB EC2 to read hotels DB (CockroachDB) certificates from SSM"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter"
        ],
        Resource = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/selena/cockroachdb/*"
      },

      # Allow decrypt SecureString
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "hotels_service_ssm_policy" {
  name        = "HotelsServiceSSMPolicy"
  description = "Allow role to read client CockroachDB certs from SSM"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter", 
          "ssm:GetParameters"
        ],
        Resource = [
          "arn:aws:ssm:${var.region}:${var.account_id}:parameter/selena/cockroachdb/*",
        ]
      }
    ]
  })
}
