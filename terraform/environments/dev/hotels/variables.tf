variable "enable_hotels_alb" {
  type    = bool
  default = true
  description = "Enable ALB and related resources for the service"
}

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

variable "ami_id" {
  type = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "iam_shared_module_source" {
  description = "Path to the shared IAM policies module"
  default     = "../../../modules/iam/iam-policies/shared"
}

variable "ec2_ecr_access_policy_arn" {
  type        = string
  description = "ECR access policy ARN from root shared_policies"
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_1_id" {
  type = string
}

variable "my_ip_cidr" {
  type        = string
  description = "Your IP or bastion CIDR for SSH access"
}

variable "bastion_sg_id" {}
variable "user_data_file" {}
variable "ssh_allowed_cidr" {}
variable "iam_instance_profile" {}
