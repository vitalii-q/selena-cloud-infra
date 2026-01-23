# ============================================
# ACM Certificate for hotels-service (SSL/TLS)
# ============================================

# Fetch the existing Hosted Zone for the main domain selena-aws.com
data "aws_route53_zone" "main_zone" {
  name         = "selena-aws.com"
  private_zone = false
}

# ACM Certificate for hotels-service
resource "aws_acm_certificate" "hotels_service_cert" {
  domain_name       = "hotels-service.selena-aws.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "hotels-service-cert"
    Environment = "dev"
  }
}

# ACM DNS validation record for hotels-service via Route53
resource "aws_route53_record" "hotels_service_cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.hotels_service_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.main_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}

# Certificate validation
resource "aws_acm_certificate_validation" "hotels_service_cert_validation" {
  certificate_arn         = aws_acm_certificate.hotels_service_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.hotels_service_cert_validation_record : record.fqdn]
}
