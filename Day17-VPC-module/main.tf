module "vpc" {
  source = "./vpc"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = true
  single_nat_gateway = var.environment == "prod" ? false : true  # HA in prod, cost-saving elsewhere

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "nat_gateway_public_ips" {
  value = module.vpc.nat_gateway_public_ips
}