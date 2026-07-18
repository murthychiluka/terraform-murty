# --- backend.tf (in your root project, NOT the bootstrap folder) ---

terraform {
  backend "s3" {
    bucket         = "murthy143143143"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}