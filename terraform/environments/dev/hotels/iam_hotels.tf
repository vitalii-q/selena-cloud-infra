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

# =============================================
# ---------- Role for CockroachDB EC2 ---------
# =============================================
module "hotels_db_role" {
  source    = "../../../modules/iam/iam-roles/service-role"
  role_name = "selena-hotels_db-role"
  service   = "ec2.amazonaws.com"
  policies = {
    # Allow EC2 to read hotel DB (CockroachDB) certs from SSM
    HotelsDBSSMPolicy = module.hotels_policies.hotels_db_ssm_policy_arn
  }

  tags = {
    Project = "Selena"
    Service = "hotels_db"
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

    # Allow hotels-service EC2 to read CockroachDB client certs from SSM
    HotelsServiceSSMPolicy = module.hotels_policies.hotels_db_ssm_policy_arn
  }
}

