output "vpc_id" {
  value = aws_vpc.main.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "default_security_group_id" {
  value = aws_vpc.main.default_security_group_id
}

# nets
output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
output "public_subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}
output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}

# nets arrays
output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet.id,
    aws_subnet.public_subnet_2.id
  ]
}
output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet.id,
    aws_subnet.private_subnet_2.id
  ]
}

output "vpc_cidr" {
  value = var.vpc_cidr
}