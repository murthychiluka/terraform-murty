# resource "aws_instance" "name" {
     
#      ami = "ami-0cca150d127c2216f"
#      instance_type = "t3.micro"
#      count = 2
#      tags = {
#        Name = "dev-${count.index}"
#      }
# }

 resource "aws_instance" "name" {
     
     ami = "ami-0cca150d127c2216f"
     instance_type = "t3.micro"
     count = length(var.env)
     tags = {
       Name = "var.env[${count.index}]"
     }
}

variable "env" {
  type = list(string)
  default = ["dev", "qa", "prod"]
}


