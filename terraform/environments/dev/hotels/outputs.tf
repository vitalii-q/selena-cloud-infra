output "alb_dns_name" {
  value = try(module.hotels_alb[0].alb_dns_name, null)
}
