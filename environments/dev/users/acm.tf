# ACM Certificate
resource "aws_acm_certificate" "users_service_cert" {
  domain_name       = "selena.users-service.com"
  validation_method = "DNS"

  tags = {
    Environment = var.environment
    Name        = "users-service-cert"
  }
}

# DNS Validation (when use Route53)
resource "aws_route53_record" "users_service_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.users_service_cert.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id = var.route53_zone_id  # ID зоны Route53
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "users_service_cert_validation" {
  certificate_arn         = aws_acm_certificate.users_service_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.users_service_cert_validation : record.fqdn]
}


# outputs ------------------------------------------------------------------------------
output "users_service_cert_arn" {
  value = aws_acm_certificate_validation.users_service_cert_validation.certificate_arn
}