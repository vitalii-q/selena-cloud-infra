resource "aws_security_group" "this" {
  name        = var.name
  description = "${var.name} security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = lookup(ingress.value, "cidr_blocks", [])
      security_groups = lookup(ingress.value, "security_groups", [])
      description = lookup(ingress.value, "description", null)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = lookup(egress.value, "cidr_blocks", [])
      security_groups = lookup(egress.value, "security_groups", [])
      description = lookup(egress.value, "description", null)
    }
  }

    # allow SSH from bastion only if provided
    dynamic "ingress" {
      for_each = var.bastion_sg_id != null ? [1] : []

      content {
          description     = "SSH from bastion"
          from_port       = 22
          to_port         = 22
          protocol        = "tcp"
          security_groups = [var.bastion_sg_id]
      }
    }

  tags = {
    Name = var.name
  }
}
