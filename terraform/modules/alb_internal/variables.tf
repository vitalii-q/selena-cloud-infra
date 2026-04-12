variable "service_name" {
  description = "Name of the ALB service"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment (dev, prod, etc.)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR of VPC to allow internal traffic"
  type        = string
}

# Map of internal services behind the ALB
# Each service automatically creates:
# - Target Group
# - Listener Rule
variable "services" {
  description = "Internal services behind ALB"

  type = map(object({
    port              = number
    host              = string
    health_check_path = optional(string, "/health")
  }))
}