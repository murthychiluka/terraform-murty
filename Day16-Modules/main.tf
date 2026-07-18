module "network" {
  source = "./VPC"

  vpc_name            = "my-vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.12.0/24", "10.0.13.0/24"]
}

module "alb" {
  source = "./ALB"

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}
module "ec2" {
  source = "./EC2"

  vpc_id                 = module.network.vpc_id
  private_subnet_ids     = module.network.public_subnet_ids  # using public for now
  alb_security_group_id  = module.alb.alb_security_group_id  # you'll need to output this from the alb module
  target_group_arn       = module.alb.target_group_arn
  key_name               = "devkeypair"
}