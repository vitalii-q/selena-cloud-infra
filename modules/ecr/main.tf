resource "aws_ecr_repository" "users_service" {
  name                 = "selena-users-service"
  image_tag_mutability = "MUTABLE"
  tags = {
    Environment = var.environment
    Service     = "users-service"
  }
}

# Lifecycle policy for ECR: keep only last 3 tagged images
resource "aws_ecr_lifecycle_policy" "users_service_policy" {
  repository = aws_ecr_repository.users_service.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only last 3 tagged images with v*"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]        # leave all tags beginning with “v”
          countType     = "imageCountMoreThan"
          countNumber   = 3
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last 1 latest tag"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["latest"]   # process separately latest
          countType     = "imageCountMoreThan"
          countNumber   = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}


