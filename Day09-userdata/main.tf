resource "aws_instance" "name" {
     
     ami = var.ami_id
     instance_type = var.instance_type
     user_data = file("test.sh")
     tags = {
       "name" = "dev"
     }
}