resource "aws_cloudwatch_log_group" "selena_logs" {
  name              = "/ecs/selena-users-service"
  retention_in_days = 7

  tags = {
    Service = "users-service"
    Environment = "dev"
  }
}
