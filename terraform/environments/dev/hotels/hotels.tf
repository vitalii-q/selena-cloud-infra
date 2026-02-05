module "hotels_alb" {
  source              = "../../../modules/alb"
  count               = 0

  name                = "selena-hotels-alb"
  vpc_id              = var.vpc_id

  subnets             = [
    var.public_subnet_1_id,      # subnet in AZ 1
    var.public_subnet_2_id       # subnet in AZ 2
  ]

  alb_sg_name         = "hotels-alb-sg"

  #security_group_id  = module.hotels_asg.asg_sg_id
  security_group_id   = try(module.hotels_alb[0].alb_sg_id, null)
  target_port         = 9064
  health_check        = "/test"

  certificate_arn     = aws_acm_certificate_validation.hotels_service_cert_validation.certificate_arn
}

module "hotels_asg" {
  source = "../../../modules/asg"
  count  = length(module.hotels_alb) == 0 ? 0 : 1     # # If ALB is disabled → ASG is not needed and is not being created.

  service_name         = "hotels"
  service_port         = 9064

  desired_capacity     = 0
  min_size             = 0
  max_size             = 0

  user_data_file       = "${path.root}/../../scripts/userdata/userdata_hotels_asg.sh"

  ami_id               = var.ami_id
  vpc_id               = var.vpc_id
  subnet_ids           = [var.public_subnet_1_id, var.public_subnet_2_id]
  instance_type        = "t3.nano"
  key_name             = var.key_name
  iam_instance_profile = module.hotels_role.instance_profile
  environment          = var.environment

  alb_tg_arn           = module.hotels_alb[0].alb_tg_arn
}