variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
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

variable "key_name" {
  description = "SSH key pair name"
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

variable "availability_zone_2" {
  description = "Secondary availability zone"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for primary private subnet"
  type        = string
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for secondary private subnet"
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

variable "environment" {
  description = "Окружение (dev, prod и т.д.)"
  type        = string
  default     = "dev"
}

variable "alert_email" {
  description = "Email для уведомлений CloudWatch"
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

# Port on which the users-service container is running
variable "users_service_port" {
  description = "Port for users-service container"
  type        = number
  default     = 9065
}

# Health check path for the Load Balancer
variable "users_health_check_path" {
  description = "Health check path for users-service"
  type        = string
  default     = "/test"
}
