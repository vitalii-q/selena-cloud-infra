resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn

  # The network where the cluster will operate
  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Kubernetes version
  version = var.k8s_version
}
