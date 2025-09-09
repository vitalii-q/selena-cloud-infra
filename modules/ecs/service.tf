resource "aws_ecs_service" "users_service" {
  name            = "selena-users-service"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = aws_ecs_task_definition.users_service_task.arn
  desired_count   = 1
  launch_type     = "EC2"

  network_configuration {
    subnets          = [module.vpc.public_subnet_id]
    security_groups  = [module.ec2.users_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = module.alb_users.target_group_arn
    container_name   = "selena-users-service"
    container_port   = 8080
  }

  depends_on = [module.alb.users_service_tg_arn]
}
