output "private_ip" {
  value       = var.enable_instance ? aws_instance.cockroachdb[0].private_ip : null
  description = "Private IP of CockroachDB instance"
}

output "private_dns" {
  value       = var.enable_instance ? aws_instance.cockroachdb[0].private_dns : null
  description = "Private DNS of CockroachDB instance"
}