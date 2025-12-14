resource "aws_iam_role_policy_attachment" "attach" {
  for_each   = toset(var.policies)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}
