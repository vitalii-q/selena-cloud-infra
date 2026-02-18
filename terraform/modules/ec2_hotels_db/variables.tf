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
  default = "0.0.0.0/32" # temporarily, then we can do bastion-only
}

variable "iam_instance_profile" {
  type = string
  default = ""  # if there is an IAM for EC2, we will send it here
}

variable "vpc_cidr" {
  description = "VPC CIDR for security group ingress rules"
  type        = string
}

# Path to hotels DB (CockroachDB) certificates directory
variable "certs_path" {
  description = "Path to CockroachDB certs directory"
  type        = string
}

variable "client_certs_path" {
  description = "Path to CockroachDB client certs"
  type        = string
}

variable "availability_zone" {
  description = "AZ for EBS volume"
  type = string
}
