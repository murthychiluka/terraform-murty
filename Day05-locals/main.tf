# provider "aws" {
#     region = us-east-1
# }

resource "aws_instance" "web" {
    ami= "ami-0cca150d127c2216f"
    instance_type = local.instance_type

    tags = merge(local.common_tags)
    #     Name = "Dev-Server"
    
}