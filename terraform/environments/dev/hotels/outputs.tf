output "alb_dns_name" {
  value = try(module.hotels_alb[0].alb_dns_name, null)
}

output "hotels_db_private_dns" {
  value = try(module.hotels_db[0].private_dns, null)
}

output "hotels_db_private_ip" {
  value = try(module.hotels_db[0].private_ip, null)
}