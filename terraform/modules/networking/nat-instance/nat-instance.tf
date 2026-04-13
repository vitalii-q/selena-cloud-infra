data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "nat" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id = var.public_subnet_id
  key_name = var.key_name
  vpc_security_group_ids = [
    module.nat_sg.id
  ]
  associate_public_ip_address = true
  source_dest_check = false

  user_data = <<-EOF
    #!/bin/bash

    # Enable IP forwarding
    sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

    # Install iptables service
    yum install -y iptables-services

    # Configure NAT
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

    service iptables save
    systemctl enable iptables

    EOF

  tags = {
    Name = "nat-instance"
  }
}

resource "aws_route" "private_nat_route" {
  for_each = {
    rt1 = var.private_route_table_ids[0]
    rt2 = var.private_route_table_ids[1]
  }

  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  
  network_interface_id   = aws_instance.nat.primary_network_interface_id
}