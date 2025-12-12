variable "environment" {
  description = "Deployment environment (e.g. dev, prod)"
  type        = string
}

variable "services" {
  type    = list(string)
  default = ["users-service", "hotels-service"]
}