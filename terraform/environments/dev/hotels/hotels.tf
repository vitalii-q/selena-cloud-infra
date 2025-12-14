# =========================================
# --- Policies to users local directory ---
# =========================================
locals {
  ec2_role_policies = [
    "arn:aws:iam::${var.account_id}:policy/Ec2StopStartPolicy",
    "arn:aws:iam::${var.account_id}:policy/EC2SecretsAccessPolicy",
    "arn:aws:iam::${var.account_id}:policy/EC2S3AccessPolicy",
    "arn:aws:iam::${var.account_id}:policy/EC2RDSReadPolicy",
    "arn:aws:iam::${var.account_id}:policy/SelenaEC2CloudWatchMetricsPolicy"
  ]
}

module "hotels_ec2_role" {
  source        = "../../../modules/iam-roles"
  role_name     = "selena-hotels-ec2-role"
  service       = "ec2.amazonaws.com"
  account_id    = var.account_id
  region        = var.region

  policies      = local.ec2_role_policies

  tags = {
    Project = "Selena"
    Service = "hotels-service"
  }
}

module "hotels_cloudwatch_role" {
  source        = "../../../modules/iam-roles"
  role_name     = "selena-hotels-cloudwatch-role"
  service       = "ec2.amazonaws.com"
  account_id    = var.account_id
  region        = var.region

  policies  = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]

  tags = {
    Project = "Selena"
    Service = "hotels-service"
  }
}

