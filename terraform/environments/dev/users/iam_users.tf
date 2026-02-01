# =============================================
# ---------- Roles for users-service ----------
# =============================================
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

# ============================================
# -------- Policies for users-service --------
# ============================================
module "users_policies" {
  source     = "../../../modules/iam/iam-policies/users"
  account_id = var.account_id
  region     = var.region
}

locals {
  ec2_role_policies = {
    EC2S3AccessPolicy      = module.users_policies.ec2_s3_access_policy_arn
    EC2SecretsAccessPolicy = module.users_policies.ec2_secrets_access_policy_arn
    EC2RDSReadPolicy       = module.users_policies.ec2_rds_read_policy_arn

    ECRAccessPolicy        = var.ec2_ecr_access_policy_arn
  }
}