# =============================================
# ---------- Roles for hotels-service ---------
# =============================================
module "hotels_role" {
  source        = "../../../modules/iam/iam-roles/service-role"
  role_name     = "selena-hotels-role"
  service       = "ec2.amazonaws.com"

  policies      = local.ec2_role_policies

  tags = {
    Project = "Selena"
    Service = "hotels-service"
  }
}

# ============================================
# -------- Policies for hotels-service -------
# ============================================
module "hotels_policies" {
  source     = "../../../modules/iam/iam-policies/hotels"
  account_id = var.account_id
  region     = var.region
}

locals {
  ec2_role_policies = {
    # Allows EC2 to read secrets for hotels-service
    EC2SecretsAccessPolicy = module.hotels_policies.ec2_secrets_access_policy_arn

    # Shared policy from shared module
    ECRAccessPolicy        = var.ec2_ecr_access_policy_arn
  }
}

