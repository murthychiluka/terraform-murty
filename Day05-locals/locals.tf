locals {
  environment = "dev"
  instance_type = "t3.micro"
  common_tags = {
    environment = local.environment
    owner = "murthy"
    project = "terraform"
  }
}