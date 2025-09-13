resource "aws_ecs_service" "users_service" {
  name            = "selena-users-service"
  cluster         = aws_ecs_cluster.users_cluster.id
  task_definition = aws_ecs_task_definition.users_service_task.arn
  desired_count   = 1
  launch_type     = var.launch_type

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.users_sg_id]
  }

  load_balancer {
    target_group_arn = var.users_alb_tg_arn
    container_name   = "selena-users-service"
    container_port   = 8080
  }

  depends_on = [aws_ecs_task_definition.users_service_task]
}
