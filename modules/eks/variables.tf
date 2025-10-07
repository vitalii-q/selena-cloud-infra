variable "eks_cluster_role_arn" {
  type = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "k8s_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

