# ============================================================
# Private Route Tables
# ============================================================

resource "aws_route_table" "private_rt_1" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project}-private-rt-1"
  }
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project}-private-rt-2"
  }
}

# ============================================================
# Private Subnet Associations
# ============================================================

resource "aws_route_table_association" "private_subnet_assoc_1" {
  subnet_id      = var.private_subnet_ids[0]
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "private_subnet_assoc_2" {
  subnet_id      = var.private_subnet_ids[1]
  route_table_id = aws_route_table.private_rt_2.id
}