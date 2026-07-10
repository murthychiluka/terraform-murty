locals {
  region        = "us-east-1"
  instance_type = "t3.micro"
  ami_id= "ami-0cca150d127c2216f"
}

resource "aws_instance" "name" {
  ami = local.ami_id
  instance_type = local.instance_type
  region = local.region
}