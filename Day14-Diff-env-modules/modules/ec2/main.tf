
resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  #key_name = var.key_name
  tags = {
    Name = "${var.env}-ec2"
  }
}

# In the above code use ec2 module instead of resource block