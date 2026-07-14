
# resource "aws_vpc" "name" {
#     cidr_block = "10.1.0.0/16"
#     tags = {
#       name = "dev_vpc"
#     }
# }

resource "aws_instance" "web" {
  ami           = "ami-0cca150d127c2216f"  # Example Amazon Linux 2 AMI
  instance_type = lookup(var.instance_type, "dev", "t2.nano")

  tags = {
    Name = "Dev-Server"
  }
}