resource "aws_ecr_repository" "users_service" {
  name                 = "selena-users-service"
  image_tag_mutability = "MUTABLE"
  tags = {
    Environment = var.environment
    Service     = "users-service"
  }
}

