resource "aws_ecs_task_definition" "users_service_task" {
  family                   = "selena-users-service-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]  # Для ASG. Если Fargate — ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "selena-users-service"
      image     = "${var.users_service_ecr_uri}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      environment = [
        {
          name  = "DATABASE_URL"
          value = "postgresql://${var.db_username}:${var.db_password}@${var.db_endpoint}:5432/users_db"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.logs_group_name
          "awslogs-region"        = "eu-central-1"
          "awslogs-stream-prefix" = "selena-users-service"
        }
      }
    }
  ])
}
