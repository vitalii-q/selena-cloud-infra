# =========================
# ACM Certificate (SSL/TLS)
# =========================

# Provider for us-east-1 (Route53 Hosted Zone)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Hosted Zone in us-east-1
data "aws_route53_zone" "main_zone_us_east_1" {
  provider    = aws.us_east_1
  name        = "selena-aws.com"
  private_zone = false
}

# ACM Certificate for users-service
resource "aws_acm_certificate" "users_service_cert" {
  domain_name       = "users-service.selena-aws.com"
  validation_method = "DNS"

  tags = {
    Environment = var.environment
    Name        = "users-service-cert"
  }
}

# DNS Validation via Route53
resource "aws_route53_record" "users_service_cert_validation" {
  provider = aws.us_east_1

  for_each = {
    for dvo in aws_acm_certificate.users_service_cert.domain_validation_options : dvo.domain_name => dvo
  }

  # zone_id = var.route53_zone_id
  zone_id = data.aws_route53_zone.main_zone_us_east_1.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

# Certificate validation
resource "aws_acm_certificate_validation" "users_service_cert_validation" {
  certificate_arn         = aws_acm_certificate.users_service_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.users_service_cert_validation : record.fqdn]
}