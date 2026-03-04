output "bastion_public_ip" {
  value       = length(aws_instance.bastion) > 0 ? aws_instance.bastion[0].public_ip : null
  description = "Bastion public IP (if instance exists)"
}

output "bastion_private_ip" {
  value       = length(aws_instance.bastion) > 0 ? aws_instance.bastion[0].private_ip : null
  description = "Bastion private IP (if instance exists)"
}
