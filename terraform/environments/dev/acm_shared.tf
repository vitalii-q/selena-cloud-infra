provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

data "aws_route53_zone" "main_zone_us_east_1" {
  provider    = aws.us_east_1
  name        = "selena-aws.com"
  private_zone = false
}

# One certificate for all services (SAN/wildcard)
resource "aws_acm_certificate" "shared_services_cert" {
  domain_name       = "*.selena-aws.com"
  validation_method = "DNS"

  tags = {
    Environment = var.environment
    Name        = "shared-services-cert"
  }
}

# DNS Validation records
resource "aws_route53_record" "shared_services_cert_validation" {
  provider = aws.us_east_1

  for_each = {
    for dvo in aws_acm_certificate.shared_services_cert.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id = data.aws_route53_zone.main_zone_us_east_1.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

# Certificate validation
resource "aws_acm_certificate_validation" "shared_services_cert_validation" {
  certificate_arn         = aws_acm_certificate.shared_services_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.shared_services_cert_validation : record.fqdn]
}