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

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "env" {
  description = "Environment"
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

variable "users_service_ami_id" {
  description = "AMI ID for users-service instances"
  type        = string
}

