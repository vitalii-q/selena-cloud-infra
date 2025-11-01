# -----------------------
# USERS-SERVICE
# -----------------------

resource "aws_instance" "users_service" {
  count                       = 1
  ami                         = var.ami_id
  # ami                       = data.aws_ami.amazon_linux_2023.id dynamic
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.users_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = var.instance_profile

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  user_data = file("${path.root}/../../scripts/userdata/userdata.sh") # v2

  tags = {
    Name = "users-service-instance"
  }
}

resource "aws_security_group" "users_sg" {
  name        = "users-service-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id

  # depends_on = [aws_instance.users_service]

  # who can connect to the resource (ingress)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH access
  }

  ingress {
    from_port   = 9065
    to_port     = 9065
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow users-service access on port 9065"
  }

  # wrehe can the resource send data (egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Elastic IP
/* resource "aws_eip" "this" {
  count    = 1
  instance = aws_instance.users_service[0].id

  depends_on = [
    aws_instance.users_service[0]
  ]

  lifecycle {
    prevent_destroy = true
  }
} */

