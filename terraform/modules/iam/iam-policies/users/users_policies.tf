# --- S3 access ONLY for users-service ---
resource "aws_iam_policy" "ec2_s3_access_policy" {
  name        = "EC2S3AccessPolicy"
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

# --- Secrets Manager (users DB) ---
resource "aws_iam_policy" "ec2_secrets_access_policy" {
  name        = "EC2SecretsAccessPolicy"
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
        Resource = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:selena-users-db-dev*"
      }
    ]
  })
}

# --- RDS describe (users DB) ---
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

