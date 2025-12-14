# =============================================
# --- Policies and Roles for hotels-service ---
# =============================================
locals {
  ec2_role_policies = [
    "arn:aws:iam::${var.account_id}:policy/Ec2StopStartPolicy",
    "arn:aws:iam::${var.account_id}:policy/SelenaEC2CloudWatchMetricsPolicy"
  ]
}