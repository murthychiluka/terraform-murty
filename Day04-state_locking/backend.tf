terraform {
  backend "s3" {
    bucket = "aaaaaaaahhhhhh"
    key    = "Day4/terraform.tfstate"
    region = "us-east-1"
  }
}