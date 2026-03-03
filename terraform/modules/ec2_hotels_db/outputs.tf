output "private_dns" {
  value = try(aws_instance.cockroachdb[0].private_dns, null)
}

output "private_ip" {
  value = try(aws_instance.cockroachdb[0].private_ip, null)
}