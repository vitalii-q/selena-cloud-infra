resource "aws_iam_user" "terraform_user" {
  name = "terraform-user"

  # ensure policies are deleted first
  depends_on = [
    aws_iam_user_policy_attachment.attach_policy,
    aws_iam_user_policy.terraform_user_policy
  ]
}

resource "aws_iam_policy" "terraform_admin_policy" { TODO: add least privileges policy
  name        = "TerraformFullAccessPolicy"
  description = "Policy for Terraform to fully manage AWS infrastructure"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "*"
        Resource = "*"
      }
    ]
  })
}

# add inline-policy, accessing creation IAM resources
resource "aws_iam_user_policy" "terraform_user_policy" {
  name = "terraform-user-policy"
  user = aws_iam_user.terraform_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:CreatePolicy",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:CreateRole",
          "iam:PassRole",
          "iam:CreateInstanceProfile",
          "iam:AddRoleToInstanceProfile"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:Describe*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = aws_iam_policy.terraform_admin_policy.arn

  # ensure this is destroyed before deleting user
  depends_on = [aws_iam_user_policy.terraform_user_policy]
}

resource "aws_iam_access_key" "terraform_access_key" {
  user = aws_iam_user.terraform_user.name
}

output "access_key_id" {
  value = aws_iam_access_key.terraform_access_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.terraform_access_key.secret
  sensitive = true
}
