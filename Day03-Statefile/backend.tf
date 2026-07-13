terraform {
  backend "s3" {
    bucket = "murthy-terraform"
    key    = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true ##supports terrafrom latest version >=1.10
    # dynamodb_table = "terraform-state-locking"  #if terrafrom version <1.10 use below code
  }
}
