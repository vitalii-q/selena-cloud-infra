resource "aws_secretsmanager_secret" "users_db_secret" {
  name        = "selena-users-db-dev"
  description = "PostgreSQL credentials for users-service dev environment"
  tags = {
    Environment = "dev"
    Project     = "selena"
  }
}

resource "aws_secretsmanager_secret_version" "users_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.users_db_secret.id
  secret_string = jsonencode({
    USERS_POSTGRES_DB_HOST     = var.users_db_host
    USERS_POSTGRES_DB_USER     = var.users_db_user
    USERS_POSTGRES_DB_PASS     = var.users_db_pass
    USERS_POSTGRES_DB_NAME     = var.users_db_name
    USERS_POSTGRES_DB_PORT_INNER = var.users_db_port_inner
    USERS_POSTGRES_DB_SSLMODE  = var.users_db_sslmode
  })
}

# Secret variables ============================
variable "users_db_host" {
  type = string
}

variable "users_db_user" {
  type = string
}

variable "users_db_pass" {
  type      = string
  sensitive = true
}

variable "users_db_name" {
  type = string
}

variable "users_db_port_inner" {
  type = number
  default = 5432
}

variable "users_db_sslmode" {
  type    = string
  default = "require"
}
