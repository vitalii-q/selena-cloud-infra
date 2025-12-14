provider "aws" {
  region = "eu-central-1"
  profile = "terraform"
}

module "vpc" {
  source                = "../../modules/vpc"

  project               = "selena"
  vpc_cidr              = "10.0.0.0/16"

  public_subnet_cidr    = "10.0.1.0/24"
  private_subnet_cidr   = "10.0.2.0/24"

  public_subnet_cidr_2  = "10.0.3.0/24"
  private_subnet_cidr_2 = "10.0.4.0/24"

  availability_zone     = "eu-central-1a"
  availability_zone_2   = var.availability_zone_2
}

module "users" {
  source = "./users"

  # variables
  account_id                  = data.aws_caller_identity.current.account_id
  region                      = var.region

  private_subnet_cidr_2       = var.private_subnet_cidr_2
  availability_zone_2         = var.availability_zone_2
  ami_id                      = var.ami_id
  key_name                    = var.key_name
  env                         = var.env
  alert_email                 = var.alert_email
  environment                 = var.environment
  users_service_ami_id        = var.ami_id
  default_security_group_id   = module.vpc.default_security_group_id

  route53_zone_id             = data.aws_route53_zone.main_zone.zone_id 

  # certificate_arn           = aws_acm_certificate_validation.users_service_cert_validation.certificate_arn

  public_subnet_1_id          = module.vpc.public_subnet_id
  public_subnet_2_id          = module.vpc.public_subnet_2_id
  vpc_id                      = module.vpc.vpc_id
  db_subnet_group             = module.vpc.db_subnet_group

  # Secret variables
  users_db_host               = var.users_db_host
  users_db_user               = var.users_db_user
  users_db_pass               = var.users_db_pass
  users_db_name               = var.users_db_name
}

module "hotels" {
  source          = "./hotels"

  # variables
  account_id      = data.aws_caller_identity.current.account_id
  region          = var.region

  route53_zone_id = var.route53_zone_id
  environment     = var.environment
}

/*module "bookings" {
  source = "./bookings"

  route53_zone_id = var.route53_zone_id
  environment     = var.environment
}*/

# Account id
data "aws_caller_identity" "current" {}

# =====================================
# --- Policies and Roles for Selena ---
# =====================================
module "shared_policies" {
  source     = "../../modules/iam/iam-policies/shared"
  account_id = var.account_id
  region     = var.region
}

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
    GitHubActionsECRPolicy = module.shared_policies.github_actions_ecr_policy_arn
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