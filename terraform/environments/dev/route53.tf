# !!! The response from the DNS with an error may be cached by the browser, checked without cache, or by third-party tools

# Fetch the existing Hosted Zone for the main domain selena-aws.com
data "aws_route53_zone" "main_zone" {
  name         = "selena-aws.com"
  private_zone = false
}

# Create DNS record for users-service pointing to ALB
resource "aws_route53_record" "users_service_alb_record" {
  zone_id = data.aws_route53_zone.main_zone.zone_id
  name    = "users-service.selena-aws.com"
  type    = "CNAME"
  ttl     = 300

  # ALB hostname from module.users
  records = [module.users.users_alb_dns_name]
}
