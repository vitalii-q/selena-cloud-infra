resource "aws_security_group" "db_sg" {
  name        = "cockroachdb-sg"
  description = "Security group for CockroachDB"
  vpc_id      = var.vpc_id

  # CockroachDB SQL (only from VPC)
  ingress {
    from_port   = 26257
    to_port     = 26257
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "CockroachDB SQL access from VPC"
  }

  # SSH (only from your IP or bastion)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
    description = "SSH access"
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "cockroachdb" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = false
  iam_instance_profile        = var.iam_instance_profile

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = file(var.user_data_file)

  tags = {
    Name = "cockroachdb-ec2"
    Role = "database"
  }
}
