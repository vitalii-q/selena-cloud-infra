variable "name" {}
variable "vpc_id" {}
variable "subnets" {
  type = list(string)
}
variable "certificate_arn" {}
variable "environment" {}