resource "aws_instance" "dev" {
    ami = "ami-0cca150d127c2216ff"
    instance_type = "t3.micro"
      tags = {
        "Name" = "dev"
      }

   #lifecycle {
     #create_before_destroy = true
    #}
   #lifecycle {
   #  prevent_destroy = true
   #}
   #lifecycle {
     #ignore_changes = [ tags ]
   #}
}



