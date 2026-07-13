# resource "aws_instance" "name" {
     
#      ami = var.ami
#      instance_type = var.instance_type
#      tags = {
#        Name = "dev-instance"
#      }
# }

resource "aws_instance" "name" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "dev-instance"
  }
}

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
}
