# Route table for public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.project}-public-rt" 
  }
}

# Default route: all Internet traffic via IGW
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"                        # the entire external internet
  gateway_id             = var.igw_id
}

# Association for first public subnet
resource "aws_route_table_association" "public_subnet_assoc_1" {
  subnet_id      = var.public_subnet_ids[0]
  route_table_id = aws_route_table.public_rt.id
}

# Association for second public subnet
resource "aws_route_table_association" "public_subnet_assoc_2" {
  subnet_id      = var.public_subnet_ids[1]
  route_table_id = aws_route_table.public_rt.id
}