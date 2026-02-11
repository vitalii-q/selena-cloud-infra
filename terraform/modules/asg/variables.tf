variable "service_name" {
  description = "Service name (users, hotels, etc.)"
  type        = string
}

variable "desired_capacity"     { type = number }
variable "min_size"             { type = number }
variable "max_size"             { type = number }

variable "service_port" {
  description = "Application port exposed by the service"
  type        = number
}

variable "user_data_file" {
  description = "Path to user_data script file"
  type        = string
}

variable "ami_id"               { type = string }
variable "instance_type"        { type = string }
variable "key_name"             { type = string }
variable "vpc_id"               { type = string }
variable "subnet_ids"           { type = list(string) } # In which subnets should ASG be run
variable "iam_instance_profile" { type = string }       # Instance Profile name (CloudWatchAgent, etc.)

variable "environment" {
  description = "Environment name, e.g., dev or prod"
  type        = string
}

variable "alb_tg_arn" {
  description = "ARN of the Target Group for users service ALB"
  type        = string
}

variable "db_host" {
  description = "Database hostname for hotels service"
  type        = string
}
