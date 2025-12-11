output "users_service_ecr_uri" {
  value = aws_ecr_repository.users_service.repository_url
}
