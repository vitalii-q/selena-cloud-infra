variable "enable_hotels_alb" {
  type        = bool
  default     = true
  description = "Enable ALB and related resources for hotel service"
}

variable "environment" {
  description = "Environment (dev, prod и etc.)"
  type        = string
  default     = "dev"
}

variable "account_id" {
  default = ""
  type = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default = "eu-central-1"
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "availability_zone" {
  description = "Primary availability zone"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for primary private subnet"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Minimum number of instances in the Auto Scaling Group
variable "users_min_size" {
  description = "Minimum number of instances for users-service"
  type        = number
  default     = 1
}

# Maximum number of instances in the Auto Scaling Group
variable "users_max_size" {
  description = "Maximum number of instances for users-service"
  type        = number
  default     = 3
}

# Desired number of instances in the Auto Scaling Group
variable "users_desired_capacity" {
  description = "Desired number of instances for users-service"
  type        = number
  default     = 1
}

variable "public_subnet_cidr_2"  { type = string }
variable "private_subnet_cidr_2" { type = string }
variable "availability_zone_2"   { type = string }
#variable "ami_id"               { type = string }
variable "key_name"              { type = string }
variable "env"                   { type = string }
variable "alert_email"           { type = string }

variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID for DNS validation"
  type        = string
  default     = "Z09863231BVIDNICLY1A1"
}

# Secret variables (used in ./users/secrets.tf)
variable "users_db_name" {default = ""}
variable "users_db_host" {default = ""}
variable "users_db_user" {default = ""}
variable "users_db_pass" {
  default = "" 
  sensitive = true
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.nano"
}
