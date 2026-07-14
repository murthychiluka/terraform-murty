resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "Dev-vpc"
    }
    
}

# resource "aws_security_group" "web_sg" {
#   name        = "web-security-group"
#   description = "Allow SSH, HTTP and HTTPS"
#   vpc_id      = aws_vpc.main.id   # Replace with your VPC ID

#   ingress {
#     # description = "Allow SSH" 
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow HTTPS"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1" # All protocols
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "web-security-group"
#   }
# }

locals {
  ingress_ports = [22,80,443]

}

resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Allow SSH, HTTP and HTTPS"
  vpc_id      = aws_vpc.main.id   # Replace with your VPC ID

  dynamic "ingress" {
    for_each = local.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow Port ${ingress.value}"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}