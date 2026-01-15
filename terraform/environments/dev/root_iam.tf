# =============================================
# ----- Shared policies for users-service -----
module "shared_policies" {
  source     = "../../modules/iam/iam-policies/shared"
  account_id = var.account_id
  region     = var.region
}

# =============================================
# ---------- Roles for users-service ----------

module "selena_cloudwatch_role" {
  source        = "../../modules/iam/iam-roles/cloudwatch-role"
  role_name     = "selena-cloudwatch-role"
  service       = "ec2.amazonaws.com"

  policies = {
    CloudWatchMetricsPolicy = module.shared_policies.cloudwatch_metrics_policy_arn # customer managed policies
  }

  tags = {
    Project = "Selena"
  }
}

module "github_actions_role" {   # TODO: it may need to be moved to a higher level or duplicated in hotels infrastructure
  source        = "../../modules/iam/iam-roles/github-actions-role"
  role_name     = "selena-github-actions-role"
  service       = "ec2.amazonaws.com"

  policies = {
    ECRAccessPolicy = module.shared_policies.ec2_ecr_access_policy_arn
  }

  tags = {
    Project = "Selena"
    Service = "CI/CD"
  }
}

module "instance_management_role" {
  source        = "../../modules/iam/iam-roles/service-role"
  role_name     = "selena-instance-management-role"
  service       = "ec2.amazonaws.com"

  policies = {
    Ec2StopStartPolicy = module.shared_policies.ec2_stop_start_policy_arn
  }

  tags = {
    Project = "Selena"
  }
}