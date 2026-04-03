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