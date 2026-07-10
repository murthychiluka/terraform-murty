 resource "aws_instance" "name" {
     
     ami = "ami-0cca150d127c2216f"
     instance_type = "t3.micro"
     for_each = toset(var.env)
     tags = {
       Name = each.value
     }
}

variable "env" {
  type = list(string)
  default = ["dev", "qa", "prod"]
}


