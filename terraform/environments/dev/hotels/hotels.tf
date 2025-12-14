module "hotels_role" {
  source        = "../../../modules/iam/iam-roles/service-role"
  role_name     = "selena-hotels-role"
  service       = "ec2.amazonaws.com"

  policies      = local.ec2_role_policies

  tags = {
    Project = "Selena"
    Service = "hotels-service"
  }
}
