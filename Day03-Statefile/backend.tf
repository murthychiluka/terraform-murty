terraform {
  backend "s3" {
    bucket = "murthy-terraform"
    key    = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}
