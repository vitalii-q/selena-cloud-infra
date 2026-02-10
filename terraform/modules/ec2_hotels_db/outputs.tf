output "private_ip" {
  value = aws_instance.cockroachdb.private_ip
}

output "private_dns" {
  value = aws_instance.cockroachdb.private_dns
}

output "security_group_id" {
  value = aws_security_group.db_sg.id
}
