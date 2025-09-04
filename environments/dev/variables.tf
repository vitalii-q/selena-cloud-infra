variable "region" {
  description = "AWS region"
  type        = string
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

variable "private_subnet_cidr_2" { type = string }
variable "availability_zone_2"   { type = string }
variable "ami_id"               { type = string }
variable "key_name"             { type = string }
variable "instance_type"        { type = string }
variable "env"                  { type = string }
variable "alert_email"          { type = string }


