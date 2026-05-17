resource "aws_instance" "name" {
     
     ami = var.ami_id
     instance_type = var.instance_type
     tags = {
       Name = "Dev"
     }
}
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  
}