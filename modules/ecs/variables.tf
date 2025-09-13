variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "users_service_ecr_uri" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_endpoint" {
  type = string
}

variable "logs_group_name" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "users_sg_id" {
  type = string
}

variable "users_alb_tg_arn" {
  type = string
}

variable "users_alb_tg_depends_on" {
  type = any
}

variable "launch_type" {
  description = "ECS launch type (EC2 or FARGATE)"
  type        = string
  default     = "FARGATE"
}

variable "assign_public_ip" {
  description = "Assign public IP for ECS task"
  type        = bool
  default     = true
}

variable "cpu" {
  description = "Fargate CPU units"
  type        = string
  default     = "512"
}

variable "memory" {
  description = "Fargate memory (MB)"
  type        = string
  default     = "1024"
}
