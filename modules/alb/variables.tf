variable "name" {
  description = "Name for ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for ALB"
  type        = string
}

variable "target_port" {
  description = "Port where the target (EC2) listens"
  type        = number
  default     = 80
}

variable "health_check" {
  description = "Path for health checks"
  type        = string
  default     = "/test"
}

variable "environment" {
  description = "Environment name (e.g. dev)"
  type        = string
  default     = "dev"
}
