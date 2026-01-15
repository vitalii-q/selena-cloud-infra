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

variable "db_subnet_group" { 
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

variable "public_subnet_1_id" {
  description = "First public subnet ID"
  type        = string
}

variable "public_subnet_2_id" {
  description = "Second public subnet ID"
  type        = string
}

variable "ec2_ecr_access_policy_arn" {
  type        = string
  description = "ECR access policy ARN from root shared_policies"
}
