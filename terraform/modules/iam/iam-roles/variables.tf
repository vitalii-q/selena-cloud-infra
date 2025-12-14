variable "region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "role_name" {
  type = string
}

variable "service" {
  type = string
}

variable "policies" {
  type = list(string)
  default = []
}

variable "tags" {
  type = map(string)
  default = {}
}