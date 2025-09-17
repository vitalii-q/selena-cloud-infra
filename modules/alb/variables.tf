variable "service_name" {
  description = "Service name (e.g., selena-users-service)"
  type        = string
}

variable "vpc_id" {
  description = "ID VPC"
  type        = string
}

variable "subnets" {
  description = "List of subnets for ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group for ALB"
  type        = string
}

variable "target_port" {
  description = "The port to which traffic will be directed (usually 8080 for a container)"
  type        = number
}
