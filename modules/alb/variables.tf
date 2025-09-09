variable "service_name" {
  description = "Имя сервиса (например, selena-users-service)"
  type        = string
}

variable "vpc_id" {
  description = "ID VPC"
  type        = string
}

variable "subnets" {
  description = "Список подсетей для ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group для ALB"
  type        = string
}

variable "target_port" {
  description = "Порт, на который будет идти трафик (обычно 8080 для контейнера)"
  type        = number
}
