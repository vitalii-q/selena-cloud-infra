# ECR Repositories
resource "aws_ecr_repository" "services" {
  for_each = toset(var.services)

  name                 = "selena-${each.key}"
  image_tag_mutability = "MUTABLE"

  tags = {
    Environment = var.environment
    Service     = each.key
  }
}

# Lifecycle Policies
resource "aws_ecr_lifecycle_policy" "services_policy" {
  for_each   = aws_ecr_repository.services
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only last 3 tagged images with v*"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
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
          tagPrefixList = ["latest"]    # process separately latest
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
