locals {
  ecr_name = "${var.default_app_name}"

  common_tags = {
    Application = "${var.default_app_name}"
  }
}