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
  ami                         = "ami-025ce1fb05928304b"    # get in infrastructure/terraform/packer/templates/cockroachdb.pkr.hcl
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  # Attach IAM role with SSM policy
  iam_instance_profile        = var.iam_instance_profile

  /*root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }*/

  tags = {
    Name = "cockroachdb-ec2"
    Role = "database"
  }
}

# ============================================================
# Persistent EBS volume for CockroachDB data
# ============================================================

resource "aws_ebs_volume" "cockroachdb_data" {
  availability_zone = aws_instance.cockroachdb.availability_zone
  size = 20
  type = "gp3"

  tags = {
    Name = "cockroachdb-data"
  }

  lifecycle {
    prevent_destroy = true           # to avoid losing hotels DB data
  }
}

# ============================================================
# Attach volume to EC2
# ============================================================

resource "aws_volume_attachment" "cockroachdb_data_attach" {
  device_name = "/dev/xvdb"
  volume_id = aws_ebs_volume.cockroachdb_data.id
  instance_id = aws_instance.cockroachdb.id
}
