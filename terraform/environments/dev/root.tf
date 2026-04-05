provider "aws" {
  region = "eu-central-1"
  profile = "terraform"
}

# Account id
data "aws_caller_identity" "current" {}


locals {
  enable_shared_alb = var.enable_users_alb || var.enable_hotels_alb
}

module "vpc" {
  source                = "../../modules/vpc"

  project               = "selena"
  region                = var.region
  vpc_cidr              = "10.0.0.0/16"

  public_subnet_cidr    = "10.0.1.0/24"
  private_subnet_cidr   = "10.0.2.0/24"

  public_subnet_cidr_2  = "10.0.3.0/24"
  private_subnet_cidr_2 = "10.0.4.0/24"

  availability_zone     = var.availability_zone
  availability_zone_2   = var.availability_zone_2
}

module "shared_alb" {
  source          = "../../modules/alb_shared"
  name            = "selena-shared-alb"
  count           = local.enable_shared_alb ? 1 : 0

  vpc_id          = module.vpc.vpc_id
  subnets         = [
    module.vpc.public_subnet_id,
    module.vpc.public_subnet_2_id
  ]

  certificate_arn = aws_acm_certificate.shared_services_cert.arn
  environment     = var.environment
}

module "internal_alb" {
  source            = "../../modules/alb_internal"
  service_name      = "internal-alb"
  count             = local.enable_shared_alb ? 1 : 0

  vpc_id            = module.vpc.vpc_id
  private_subnets   = [module.vpc.private_subnet_id, module.vpc.private_subnet_2_id]

  vpc_cidr          = module.vpc.vpc_cidr

  environment       = var.environment
}

module "nat_instance" {
  source                  = "../../modules/nat-instance"
  count                   = local.enable_shared_alb ? 1 : 0

  instance_type           = "t3.nano"

  vpc_id                  = module.vpc.vpc_id
  public_subnet_id        = module.vpc.public_subnet_ids[0]
  private_route_table_ids = module.vpc.private_route_table_ids
  key_name                = "selena-aws-key"
}

module "users" {
  source = "./users"

  depends_on = [
    module.nat_instance
  ]

  # Resource management
  enable_users_alb            = var.enable_users_alb
  enable_users_db             = var.enable_users_db

  # variables
  account_id                  = data.aws_caller_identity.current.account_id
  region                      = var.region

  private_subnet_cidr_2       = var.private_subnet_cidr_2
  availability_zone_2         = var.availability_zone_2
  ami_id                      = data.aws_ami.selena_base.id
  key_name                    = var.key_name
  env                         = var.env
  alert_email                 = var.alert_email
  environment                 = var.environment
  default_security_group_id   = module.vpc.default_security_group_id

  alb_tg_arn                  = try(module.shared_alb[0].users_tg_arn, null)
  alb_listener_arn            = try(module.shared_alb[0].https_listener_arn, null)

  route53_zone_id             = data.aws_route53_zone.main_zone.zone_id

  vpc_id                      = module.vpc.vpc_id
  public_subnet_1_id          = module.vpc.public_subnet_id
  public_subnet_2_id          = module.vpc.public_subnet_2_id
  private_subnet_1_id         = module.vpc.private_subnet_id
  private_subnet_2_id         = module.vpc.private_subnet_2_id
  db_subnet_group             = module.vpc.db_subnet_group

  internal_alb_sg_id          = try(module.internal_alb[0].internal_alb_sg_id, null)

  # Policies
  ec2_ecr_access_policy_arn   = module.shared_policies.ec2_ecr_access_policy_arn
}

module "hotels" {
  source                      = "./hotels"

  depends_on = [
    module.nat_instance
  ]

  # Resource management
  enable_hotels_alb           = var.enable_hotels_alb
  enable_hotels_db            = var.enable_hotels_db

  # variables
  account_id                  = data.aws_caller_identity.current.account_id
  region                      = var.region
  availability_zone           = var.availability_zone

  ami_id                      = data.aws_ami.selena_base.id
  key_name                    = var.key_name

  vpc_id                      = module.vpc.vpc_id
  public_subnet_1_id          = module.vpc.public_subnet_id
  public_subnet_2_id          = module.vpc.public_subnet_2_id
  private_subnet_1_id         = module.vpc.private_subnet_id
  private_subnet_2_id         = module.vpc.private_subnet_2_id

  route53_zone_id             = var.route53_zone_id
  environment                 = var.environment

  bastion_sg_id               = module.bastion_sg.id
  user_data_file              = "${path.root}/../../scripts/userdata/userdata_cockroach.sh"
  ssh_allowed_cidr            = "0.0.0.0/32"
  iam_instance_profile        = ""

  vpc_cidr                    = module.vpc.vpc_cidr
  my_ip_cidr                  = "0.0.0.0/32"

  alb_tg_arn                  = try(module.shared_alb[0].hotels_tg_arn, null)
  alb_listener_arn            = try(module.shared_alb[0].https_listener_arn, null)

  internal_alb_sg_id          = try(module.internal_alb[0].internal_alb_sg_id, null)

  # Policies
  ec2_ecr_access_policy_arn   = module.shared_policies.ec2_ecr_access_policy_arn
}

/*module "bookings" {
  source = "./bookings"

  route53_zone_id = var.route53_zone_id
  environment     = var.environment
}*/

module "bastion" {
  source           = "../../modules/bastion"
  enable_instance  = var.enable_bastion

  project          = "selena"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id

  ami_id           = data.aws_ami.selena_base.id
  key_name         = var.key_name

  bastion_sg_id    = module.bastion_sg.id
}


# ============================================================
# Root SG
# ============================================================

# ProxyJump SSH connection: 
# ssh -i ~/.ssh/selena-aws-key.pem -o ProxyCommand="ssh -i ~/.ssh/selena-aws-key.pem -W %h:%p ec2-user@<bastion_public_ip>" ec2-user@<service_private_ip>
# ssh -i /Users/vitaly/.ssh/selena-aws-key.pem -o ProxyJump=ec2-user@<bastion_public_ip> ec2-user@<service_private_ip>
module "bastion_sg" {
  source = "../../modules/networking/security_group"

  name   = "selena-bastion-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "SSH from anywhere (temporary, dev only)"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  bastion_sg_id = null
}