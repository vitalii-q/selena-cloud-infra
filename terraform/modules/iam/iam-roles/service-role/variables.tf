variable "role_name" {
  type = string
}

variable "service" {
  type = string
}

variable "policies" {
  type = map(string)
}

variable "tags" {
  type = map(string)
  default = {}
}