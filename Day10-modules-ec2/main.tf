resource "aws_instance" "name" {
     ami = var.ami_id
     instance_type = var.instance_type
     
     associate_public_ip_address = true
     tags = {
         Name = var.tags
     }
}