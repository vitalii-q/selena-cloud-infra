# Update CockroachDB CA certificate in SSM with command:
# aws ssm put-parameter --name "/selena/cockroachdb/ca.crt" --type SecureString --overwrite --value "$(cat ca.crt)"
resource "aws_ssm_parameter" "ca_crt" {
  name  = "/selena/cockroachdb/ca.crt"
  type  = "SecureString"

  value = file("${var.server_certs_path}/ca.crt")

  overwrite = true      # auto overwrite the file when it has changed
}

# Store CockroachDB node certificate in SSM
/*resource "aws_ssm_parameter" "node_crt" {
  name  = "/selena/cockroachdb/node.crt"
  type  = "SecureString"

  value = file("${var.server_certs_path}/node.crt")

  overwrite = true
}*/

# Store CockroachDB node private key in SSM
/*resource "aws_ssm_parameter" "node_key" {
  name  = "/selena/cockroachdb/node.key"
  type  = "SecureString"

  value = file("${var.server_certs_path}/node.key")

  overwrite = true
}*/

# Update client cert in SSM with command:
# aws ssm put-parameter --name "/selena/cockroachdb/client.hotels_user.crt" --type SecureString --overwrite --value "$(cat client.hotels_user.crt)"
resource "aws_ssm_parameter" "client_crt" {
  name  = "/selena/cockroachdb/client.hotels_user.crt"
  type  = "SecureString"

  value = file("${var.client_certs_path}/client.hotels_user.crt")

  overwrite = true   # auto overwrite the file when it has changed
}

# Update client key in SSM with command:
# aws ssm put-parameter --name "/selena/cockroachdb/client.hotels_user.key" --type SecureString --overwrite --value "$(cat client.hotels_user.key)"
resource "aws_ssm_parameter" "client_key" {
  name  = "/selena/cockroachdb/client.hotels_user.key"
  type  = "SecureString"

  value = file("${var.client_certs_path}/client.hotels_user.key")

  overwrite = true   # auto overwrite the file when it has changed
}
