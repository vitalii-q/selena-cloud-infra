module "hotels_alb_service" {
  source = "../../../modules/alb_service"
  count = var.enable_hotels_alb ? 1 : 0
  service_name = "hotels"

  listener_arn = var.alb_listener_arn
  vpc_id = var.vpc_id
  target_port = 9064
  health_check = "/health"
  path_pattern = "hotels-service.selena-aws.com"
  priority = 10

  environment = var.environment
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
  subnet_ids = [
    var.private_subnet_1_id,
    var.private_subnet_2_id
  ]
  instance_type        = "t3.nano"
  volume_ebs           = 8
  key_name             = var.key_name
  iam_instance_profile = module.hotels_role.instance_profile
  environment          = var.environment
  sg_ids               = [module.hotels_service_sg.id]

  alb_tg_arn           = try(module.hotels_alb_service[0].alb_tg_arn, null)

  # DB 
  db_host              = var.enable_hotels_db ? module.hotels_db.private_dns : null
}

# ProxyJump SSH connection to EC2 instance (DNS hotels_db.internal.selena) with hotels DB via Bastion EC2 (get data from dev outputs)
# ssh -i ~/.ssh/selena-aws-key.pem -o ProxyCommand="ssh -i ~/.ssh/selena-aws-key.pem -W %h:%p ec2-user@<bastion_public_ip>" -L 5433:<hotels_db_private_ip>:26257 ubuntu@<hotels_db_private_ip>
# 
# ssh -i ~/.ssh/selena-aws-key.pem -o ProxyCommand="ssh -i ~/.ssh/selena-aws-key.pem -W %h:%p ec2-user@35.158.123.81" -L 5433:10.0.2.83:26257 ubuntu@10.0.2.83
#
# Update keygen when SSH connection error: ssh-keygen -R 10.0.2.50

module "hotels_db" {
  source                = "../../../modules/ec2_hotels_db"
  enable_instance       = var.enable_hotels_db

  project               = "selena-hotels"
  instance_type         = "t3.micro"         # CockroachDB requires at least ~2GB RAM
  vpc_id                = var.vpc_id
  vpc_cidr              = var.vpc_cidr
  private_subnet_id     = var.private_subnet_1_id
  availability_zone     = var.availability_zone

  ami_id                = var.ami_id
  key_name              = var.key_name

  bastion_sg_id         = var.bastion_sg_id
  user_data_file        = "${path.root}/../../scripts/userdata/userdata_cockroachdb.sh"   # disabled
  ssh_allowed_cidr      = "0.0.0.0/32"

  security_group_ids    = [module.hotels_db_sg.id]

  # Path to CockroachDB certificates
  server_certs_path     = "${path.root}/../../../../infrastructure/certs/hotels_db"
  client_certs_path     = "${path.root}/../../../../infrastructure/certs/hotels_service"

  # Attach IAM role to CockroachDB EC2
  iam_instance_profile  = module.hotels_db_role.instance_profile
}


# ============================================================
# Hotels SG
# ============================================================

module "hotels_service_sg" {
  source = "../../../modules/networking/security_group"

  name   = "hotels-service-sg"
  vpc_id = var.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    },
    {
      from_port   = 9064
      to_port     = 9064
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Hotels service access"
    },
    {
      from_port       = 9065
      to_port         = 9065
      protocol        = "tcp"
      security_groups = compact([var.internal_alb_sg_id])
      description     = "Allow traffic from internal ALB"
    }
  ]
}

module "hotels_db_sg" {
  source        = "../../../modules/networking/security_group"

  name          = "cockroachdb-sg"
  vpc_id        = var.vpc_id

  bastion_sg_id = var.bastion_sg_id

  ingress_rules = var.enable_hotels_alb ? [
    {
      from_port       = 26257
      to_port         = 26257
      protocol        = "tcp"
      security_groups = [module.hotels_service_sg.id]    # ASG hotels service
      description     = "Allow CockroachDB access from hotels service"
    }
  ] : []
}
