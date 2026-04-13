variable "enable_users_alb" {
  description = "Toggle to enable Users Service ALB"
  type        = bool
  default     = false
}

variable "enable_users_db" {
  description = "Toggle to enable Users Service RDS"
  type        = bool
  default     = false
}

variable "project" {}
variable "environment" {
  description = "Environment (dev, prod etc.)"
  type        = string
  default     = "dev"
}

variable "account_id" {
  description = "Account ID"
}

variable "region" {
  description = "AWS region"
  type        = string
  default = "eu-central-1"
}

variable "vpc_id" { 
  type = string 
}

variable "default_security_group_id" {
  description = "Default security group of the VPC"
  type        = string
}

# Port on which the users-service container is running
variable "users_service_port" {
  description = "Port for users-service container"
  type        = number
  default     = 9065
}

# Health check path for the Load Balancer
variable "users_service_health_path" {
  description = "Health check path for users-service"
  type        = string
  default     = "/test"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for secondary private subnet"
  type        = string
}

variable "availability_zone_2" {
  description = "Secondary availability zone"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "alert_email" {
  description = "Email для уведомлений CloudWatch"
  type        = string
}

# Route53 zone ID for DNS validation
variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID for DNS validation"
  type        = string
  default     = "Z09863231BVIDNICLY1A1"
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ec2_ecr_access_policy_arn" {
  type        = string
  description = "ECR access policy ARN from root shared_policies"
}

variable "alb_listener_arn" {
  description = "ARN of the HTTPS listener for users ALB"
  type        = string
  default     = null
}

variable "alb_tg_arn" {
  description = "ARN of the target group for users service ALB"
  type        = string
  default     = null
}

variable "internal_alb_sg_id" {
  type        = string
}

variable "users_internal_tg" {
  type    = string
  default = null
}

variable "private_services_sg_id" {
  description = "Shared SG for private services"
  type        = string
}