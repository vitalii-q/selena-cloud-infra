output "services_ecr_uri" {
  value = { for s, r in aws_ecr_repository.services : s => r.repository_url }
  description = "ECR repository URLs for all services"
}
