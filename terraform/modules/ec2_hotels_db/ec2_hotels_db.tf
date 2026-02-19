# ============================================================
# CockroachDB EC2 instance
# ============================================================

resource "aws_instance" "cockroachdb" {
  ami                         = "ami-05542aad8ef270947"    # get in infrastructure/terraform/packer/templates/cockroachdb.pkr.hcl
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = var.security_group_ids
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
  availability_zone = var.availability_zone
  size              = 20
  type              = "gp3"

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
