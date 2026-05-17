terraform {
  backend "s3" {
    bucket = "aaaaaaaahhhhhh"
    key    = "Day02/terraform.tfstate"
    region = "us-east-1"
  }
}