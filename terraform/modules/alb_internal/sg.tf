# Security Group for internal ALB
resource "aws_security_group" "internal_alb_sg" {
  name        = "${var.service_name}-sg"
  vpc_id      = var.vpc_id
  description = "Internal ALB for microservices communication"

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = [var.vpc_cidr]
    description     = "Allow traffic from microservices"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }
}