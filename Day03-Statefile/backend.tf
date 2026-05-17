terraform {
  backend "s3" {
    bucket = "aaaaaaaahhhhhh"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
