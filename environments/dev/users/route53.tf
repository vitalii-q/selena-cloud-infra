# Fetch the existing Hosted Zone for the main domain selena-aws.com
data "aws_route53_zone" "main_zone" {
  name         = "selena-aws.com"  # the main domain purchased via Route 53
  private_zone = false
}

# Create DNS record for users-service pointing to ALB
resource "aws_route53_record" "users_service_alb_record" {
  zone_id = data.aws_route53_zone.main_zone.zone_id
  name    = "users-service.selena-aws.com"  # subdomain for users-service
  type    = "CNAME"
  ttl     = 300
  records = [var.users_alb_dns_name]  # ALB DNS name
}

# Export the Hosted Zone ID for use in ACM certificate DNS validation
output "users_service_route53_zone_id" {
  value = data.aws_route53_zone.main_zone.zone_id
}
