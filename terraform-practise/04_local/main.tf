
locals {
  environment = "prod"
  upper_case = upper(local.environment)
  base_path = "${path.module}/configs/${local.upper_case}"
}

resource "local_file" "service_configs1" {
  filename = "${local.base_path}/server1.sh"
  content = <<EOT
      environment = ${local.environment}
      port=3000
      EOT
}
resource "local_file" "service_configs2" {
  filename = "${local.base_path}/server2.sh"
  content = <<EOT
      environment = ${local.environment}
      port=3000
      EOT
}
resource "local_file" "service_configs3" {
  filename = "${local.base_path}/server3.sh"
  content = <<EOT
      environment = ${local.environment}
      port=3000
      EOT
}