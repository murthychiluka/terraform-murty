module "vpc" {
  source       = "./modules/vpc"
  cidr_block   = "10.0.0.0/16"
  subnet_1_cidr  = "10.0.15.0/24"
  subnet_2_cidr = "10.0.16.0/24"
  az1           = "us-east-1a"
  az2           = "us-east-1b"
}

module "ec2" {
   source        = "./modules/ec2"
   ami_id        = "ami-0cca150d127c2216f"  # Replace with valid AMI
   instance_type = "t3.micro"
   subnet_1_id     = module.vpc.subnet_1_id
}

module "rds" {
  source         = "./modules/rds"
  subnet_1_id      = module.vpc.subnet_1_id
  subnet_2_id      = module.vpc.subnet_2_id
  instance_class = "db.t3.micro"
  db_name        = "mydb"
  db_user        = "admin"
  db_password    = "Admin12345"
}

module "s3" {
    source = "./modules/s3"
    bucket = "harekrishnaterraform143143"
  

}

# module "lambda" {
#     source = "./modules/lambda"
# }