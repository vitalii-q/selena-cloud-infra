# ============================================
# --- Policies and Roles for users-service ---
# ============================================
module "users_role" {
  source        = "../../../modules/iam/iam-roles/service-role"
  role_name     = "selena-users-role"
  service       = "ec2.amazonaws.com"

  policies      = local.ec2_role_policies

  tags = {
    Project = "Selena"
    Service = "users-service"
  }
}

locals {
  ec2_role_policies = [
    "arn:aws:iam::${var.account_id}:policy/EC2S3AccessPolicy",
    "arn:aws:iam::${var.account_id}:policy/EC2SecretsAccessPolicy",
    "arn:aws:iam::${var.account_id}:policy/EC2RDSReadPolicy",
  ]
}