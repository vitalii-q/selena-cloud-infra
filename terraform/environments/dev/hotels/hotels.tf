# =============================================
# --- Policies and Roles for hotels-service ---
# =============================================
locals {
  ec2_role_policies = [
    "arn:aws:iam::${var.account_id}:policy/Ec2StopStartPolicy",
    "arn:aws:iam::${var.account_id}:policy/SelenaEC2CloudWatchMetricsPolicy"
  ]
}

module "hotels_role" {
  source        = "../../../modules/iam/iam-roles/service-role"
  role_name     = "selena-hotels-role"
  service       = "ec2.amazonaws.com"

  #policies      = local.ec2_role_policies

  tags = {
    Project = "Selena"
    Service = "hotels-service"
  }
}
