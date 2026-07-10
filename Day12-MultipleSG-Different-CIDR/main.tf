variable "allowed_ports" {
    type = map(string)
    default = {
    #key = value
    22    = "203.0.113.0/24"    # SSH (Restrict to office IP)
    80    = "0.0.0.0/0"         # HTTP (Public)
    443   = "0.0.0.0/0"         # HTTPS (Public)
    8080  = "10.0.0.0/16"       # Internal App (Restrict to VPC)
    9000  = "192.168.1.0/24"    # SonarQube/Jenkins (Restrict to VPN)
    3389  = "10.0.1.0/24"
    3000  = "10.0.2.0/24"

  }
}

# variable "sgrule" {
#     type = list(string)
#     default = [ "22", "80", "443", "8080", "9000", "3000", "8082", "8081" ]
  
# }
  
resource "aws_security_group" "devops-project-Murthy" {
  name        = "devops-project-Murthy"
  description = "Allow TLS inbound traffic"

  

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
     
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project-Murthy"
  }
}