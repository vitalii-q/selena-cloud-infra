module "ec2" {
  source           = "../../../modules/ec2"

  ami_id           = var.ami_id
  instance_count   = 0
  instance_type    = "t3.nano"
  subnet_id        = var.public_subnet_1_id
  vpc_id           = var.vpc_id
  key_name         = var.key_name
  instance_profile = module.users_role.instance_profile
}

module "users_asg" {
  source = "../../../modules/asg"

  service_name           = "users"
  service_port           = 9065

  desired_capacity       = 0
  min_size               = 0
  max_size               = 0

  user_data_file = "${path.root}/../../scripts/userdata/userdata_users_asg.sh"

  ami_id                 = var.ami_id
  vpc_id                 = var.vpc_id
  subnet_ids             = [var.public_subnet_1_id]
  instance_type          = "t3.nano"
  key_name               = var.key_name
  iam_instance_profile   = module.users_role.instance_profile
  environment            = var.environment
  #ecs_cluster_name      = "selena-users-cluster"

  alb_tg_arn = module.users_alb.alb_tg_arn
}

module "users_rds" {
  source = "../../../modules/rds"

  db_identifier          = "users-db-${var.env}"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "users_db"
  username               = "postgres"
  password               = data.aws_ssm_parameter.db_password.value
  port                   = 5432
  publicly_accessible    = false

  vpc_id                 = var.vpc_id
  
  /*vpc_security_group_ids = [
    var.default_security_group_id, 
    module.ec2.users_sg_id
  ]*/

  db_subnet_group_name   = var.db_subnet_group
  env                    = var.env

  users_ec2_sg_id        = module.ec2.users_sg_id        # security_groups EC2
  users_asg_sg_id        = module.users_asg.asg_sg_id    # security_groups ASG
}

module "users_service_s3" {
  source      = "../../../modules/s3"
  bucket_name = "selena-users-service-env-${var.environment}"
  tags = {
    Name = "users-service-env"
    Environment = var.environment
  }
}

module "cloudwatch" {
  source = "../../../modules/cloudwatch"

  ec2_instance_id              = module.ec2.instance_id
  notification_email           = var.alert_email
  selena_ec2_instance_profile  = module.users_role.instance_profile

  alerts_topic_arn             = module.sns.alerts_topic_arn
}

module "sns" {
  source      = "../../../modules/sns"
  alert_email = "vitaly2822@gmail.com"
}

data "aws_ssm_parameter" "db_password" {
  name = "/selena/dev/users-db-password"
}

module "ecr" {
  source      = "../../../modules/ecr"
  environment = var.environment
}

/*module "eks" {
  source               = "../../../modules/eks"

  eks_cluster_role_arn = module.iam.eks_cluster_role_arn

  cluster_name         = "selena-eks"
  subnet_ids           = [module.vpc.public_subnet_id, module.vpc.public_subnet_2_id]
  k8s_version          = "1.30"
}*/

module "users_alb" {
  source               = "../../../modules/alb"
  name                 = "selena-users-service-alb"
  vpc_id               = var.vpc_id

  subnets              = [
    var.public_subnet_1_id,      # subnet in AZ 1
    var.public_subnet_2_id       # subnet in AZ 2
  ]

  alb_sg_name          = "users-alb-sg"

  # ec2_instance_id    = module.ec2.instance_id
  # users_asg_name     = module.users_asg.asg_name

  security_group_id    = module.users_asg.asg_sg_id
  target_port          = 9065
  health_check         = "/test"

  certificate_arn      = aws_acm_certificate_validation.users_service_cert_validation.certificate_arn
}