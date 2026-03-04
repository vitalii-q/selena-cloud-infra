variable "enable_instance" {
  type = bool
}

variable "project" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.nano"
}

variable "bastion_sg_id" {
  description = "Security group ID for bastion"
  type        = string
}