# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apprunner_service
resource "aws_apprunner_service" "example" {
  service_name = "example"

  source_configuration {
    image_repository {
      image_configuration {
        port = "8000"
      }
      image_identifier      = "private.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = false
  }

  tags = {
    Name = "example-apprunner-service"
  }
}

resource "aws_apprunner_auto_scaling_configuration_version" "example" {
  auto_scaling_configuration_name = "example"

  max_concurrency = 50
  max_size        = 10
  min_size        = 2

  tags = {
    Name = "example-apprunner-autoscaling"
  }
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "name"
  subnets            = ["subnet1", "subnet2"]
  security_groups    = ["sg1", "sg2"]
}