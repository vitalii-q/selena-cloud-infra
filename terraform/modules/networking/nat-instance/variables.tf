variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet for NAT instance"
  type        = string
}

variable "private_route_table_ids" {
  description = "Private route tables that should use NAT"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type for NAT"
  type        = string
  default     = "t3.nano"
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "private_services_sg_id" {
  description = "Security group for private services allowed to use NAT"
  type        = string
}