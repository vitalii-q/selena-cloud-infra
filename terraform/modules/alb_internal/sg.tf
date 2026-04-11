module "internal_alb_sg" {
  source = "../networking/security_group"

  name   = "${var.service_name}-sg"
  vpc_id = var.vpc_id

  ingress_rules = [
    {
      description = "Allow traffic from microservices"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  bastion_sg_id = null
}