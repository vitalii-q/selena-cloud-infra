# Store CockroachDB CA certificate in SSM
resource "aws_ssm_parameter" "ca_crt" {
  name  = "/selena/cockroachdb/ca.crt"
  type  = "SecureString"

  value = file("${var.certs_path}/ca.crt")
}

# Store CockroachDB node certificate in SSM
resource "aws_ssm_parameter" "node_crt" {
  name  = "/selena/cockroachdb/node.crt"
  type  = "SecureString"

  value = file("${var.certs_path}/node.crt")
}

# Store CockroachDB node private key in SSM
resource "aws_ssm_parameter" "node_key" {
  name  = "/selena/cockroachdb/node.key"
  type  = "SecureString"

  value = file("${var.certs_path}/node.key")
}
