# !!! The response from the DNS with an error may be cached by the browser, checked without cache, or by third-party tools

# Fetch the existing Hosted Zone for the main domain selena-aws.com
data "aws_route53_zone" "main_zone" {
  name         = "selena-aws.com"
  private_zone = false
}

# ===========================
# Subdomain for users-service
# ===========================

# Create DNS record for users-service pointing to ALB
resource "aws_route53_record" "users_service_alb_record" {
  count   = var.enable_users_alb ? 1 : 0        # If ALB is disabled → DNS is not needed and is not being created.

  zone_id = data.aws_route53_zone.main_zone.zone_id
  name    = "users-service.selena-aws.com"
  type    = "A"

  alias {
    name                   = module.shared_alb[0].alb_dns_name
    zone_id                = module.shared_alb[0].alb_zone_id
    evaluate_target_health = true
  }
}


# ============================
# Subdomain for hotels-service
# ============================

resource "aws_route53_record" "hotels_service_alb_record" {
  count   = var.enable_hotels_alb ? 1 : 0       # If ALB is disabled → DNS is not needed and is not being created.

  zone_id = data.aws_route53_zone.main_zone.zone_id
  name    = "hotels-service.selena-aws.com"
  type    = "A"

  alias {
    name                   = module.shared_alb[0].alb_dns_name
    zone_id                = module.shared_alb[0].alb_zone_id
    evaluate_target_health = true
  }
}


# ==========================================================
# Private Hosted Zone for internal services
# ==========================================================

resource "aws_route53_zone" "internal_zone" {
  name = "internal.selena"

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  comment = "Private hosted zone for internal Selena services"

  tags = {
    Name        = "selena-internal-zone"
    Environment = var.environment
    Project     = "selena"
  }
}

# ==========================================================
# Internal DNS record for Hotels DB (CockroachDB)
# ==========================================================

resource "aws_route53_record" "hotels_db_internal_record" {
  count   = module.hotels.hotels_db_private_ip == null ? 0 : 1

  zone_id = aws_route53_zone.internal_zone.zone_id
  name    = "hotels_db.internal.selena"                     # Hotels DB certificates have been issued for this DNS
  type    = "A"
  ttl     = 300

  records = [
    module.hotels.hotels_db_private_ip
  ]
}
# ==========================================================
# Internal DNS record for Internal ALB
# ==========================================================
resource "aws_route53_record" "internal_alb_record" {
  zone_id = aws_route53_zone.internal_zone.zone_id
  name    = "internal-alb.selena"
  type    = "A"

  alias {
    name                   = module.internal_alb.alb_dns_name
    zone_id                = module.internal_alb.alb_zone_id
    evaluate_target_health = true
  }
}