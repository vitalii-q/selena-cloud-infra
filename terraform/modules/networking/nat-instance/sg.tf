module "nat_sg" {
  source = "../../networking/security_group"

  name   = "nat-instance-sg"
  vpc_id = var.vpc_id

    ingress_rules = [
    {
        description = "Allow traffic only from private services SG"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        security_groups = [var.private_services_sg_id]
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