module "hotels_alb" {
  source              = "../../../modules/alb"
  count               = var.enable_hotels_alb ? 1 : 0

  name                = "selena-hotels-alb"
  vpc_id              = var.vpc_id

  subnets             = [
    var.public_subnet_1_id,      # subnet in AZ 1
    var.public_subnet_2_id       # subnet in AZ 2
  ]

  alb_sg_name         = "hotels-alb-sg"

  target_port         = 9064
  health_check        = "/test"

  certificate_arn     = aws_acm_certificate_validation.hotels_service_cert_validation.certificate_arn
}

module "hotels_asg" {
  source               = "../../../modules/asg"
  count                = var.enable_hotels_alb ? 1 : 0     # # If ALB is disabled → ASG is not needed and is not being created.

  service_name         = "hotels"
  service_port         = 9064

  desired_capacity     = 1
  min_size             = 1
  max_size             = 1

  user_data_file       = "${path.root}/../../scripts/userdata/userdata_hotels_asg.sh"

  ami_id               = var.ami_id
  vpc_id               = var.vpc_id
  subnet_ids           = [var.public_subnet_1_id, var.public_subnet_2_id]
  instance_type        = "t3.nano"
  key_name             = var.key_name
  iam_instance_profile = module.hotels_role.instance_profile
  environment          = var.environment

  alb_tg_arn           = module.hotels_alb[0].alb_tg_arn

  # DB 
  db_host              = module.hotels_db.private_dns
}

# ProxyJump SSH connection to EC2 instance (DNS hotels_db.internal.selena) with hotels DB via Bastion EC2
# ssh -i ~/.ssh/selena-aws-key.pem -o ProxyCommand="ssh -i ~/.ssh/selena-aws-key.pem -W %h:%p ec2-user@<bastion_public_ip>" -L 5433:<hotels_db_private_ip>:5432 ec2-user@<hotels_db_private_ip>
# 
# ssh -i ~/.ssh/selena-aws-key.pem -o ProxyCommand="ssh -i ~/.ssh/selena-aws-key.pem -W %h:%p ec2-user@18.153.207.232" -L 5433:10.0.2.82:5432 ec2-user@10.0.2.82

module "hotels_db" {
  source                = "../../../modules/ec2_hotels_db"

  project               = "selena-hotels"
  vpc_id                = var.vpc_id
  vpc_cidr              = var.vpc_cidr
  private_subnet_id     = var.private_subnet_1_id

  ami_id                = var.ami_id
  key_name              = var.key_name

  bastion_sg_id         = var.bastion_sg_id
  user_data_file        = "${path.root}/../../scripts/userdata/userdata_cockroachdb.sh"
  ssh_allowed_cidr      = "0.0.0.0/32"
  iam_instance_profile  = ""
}
