output "alb_dns_name" {
  value = try(module.hotels_alb[0].alb_dns_name, null)
}

output "hotels_db_private_dns" {
  value = module.hotels_db.private_dns
}

output "hotels_db_private_ip" {
  value = module.hotels_db.private_ip
}
