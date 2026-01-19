variable "environment" {
  description = "Environment (dev, prod etc.)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default = "eu-central-1"
}

variable "account_id" {
  description = "Account ID"
}

# Route53 zone ID for DNS validation
variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID for DNS validation"
  type        = string
  default     = "Z09863231BVIDNICLY1A1"
}

variable "vpc_id" { 
  type = string 
}

variable "public_subnet_1_id" {
  description = "First public subnet ID"
  type        = string
}

variable "public_subnet_2_id" {
  description = "Second public subnet ID"
  type        = string
}