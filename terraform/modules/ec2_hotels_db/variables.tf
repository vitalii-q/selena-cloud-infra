variable "project" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_id" {
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
  type = string
}

variable "user_data_file" {
  type = string
}

variable "ssh_allowed_cidr" {
  type    = string
  default = "0.0.0.0/32" # временно, потом можем сделать bastion-only
}

variable "iam_instance_profile" {
  type = string
  default = ""  # если есть IAM для EC2, передадим сюда
}

variable "vpc_cidr" {
  description = "VPC CIDR for security group ingress rules"
  type        = string
}
