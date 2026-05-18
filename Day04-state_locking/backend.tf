terraform {
  backend "s3" {
    bucket = "aaaaaaaahhhhhh"
    key    = "Day4/terraform.tfstate"
    region = "us-east-1"
    #use_lockfile = true      # above 1.12 version use S3 Native state locking
    dynamodb_table = "Murthy" #any version we can use dynamodb
    encrypt = true
  }
}