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

variable "ecs_cluster_name" {
  description = "ECS Cluster name to register instances"
  type        = string
}

variable "users_alb_tg_arn" {
  description = "ARN of the Target Group for users service ALB"
  type        = string
}