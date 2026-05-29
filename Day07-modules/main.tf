#resource "aws_instance" "name" {

   #  ami = var.ami_id
   #  instance_type = var.type
#}

resource "aws_vpc" "name" {
    cidr_block = var.cidr
    tags = {
      Name = "windows"
    }
    
}