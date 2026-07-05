# module "name" {
#     source = "../Day07-modules"
#     ami_id = "ami-0cca150d127c2216f"
#     type = "t3.micro"
  
# }
module "name" {
    source = "../Day07-modules"
    ami_id = var.ami_id
    type = var.type
  
}