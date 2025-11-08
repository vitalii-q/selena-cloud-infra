variable "environment" {
  description = "Environment (dev, prod etc.)"
  type        = string
  default     = "dev"
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

variable "instance_type" {
  description = "EC2 instance type"
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

variable "users_service_ami_id" {
  description = "AMI ID for users-service instances"
  type        = string
}

# Route53 zone ID for DNS validation
variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID for DNS validation"
  type        = string
}
