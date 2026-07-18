module "network" {
  source = "./VPC"

  vpc_name            = "myapp-${var.environment}-vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "rds" {
  source = "./rds"

  identifier     = var.db_identifier
  db_name        = var.db_name
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  multi_az       = var.db_multi_az

  master_username = var.db_master_username
  master_password = var.db_master_password

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids

  # no app-tier SG to reference yet in this fresh project, so leave empty for now
  allowed_security_group_ids = []

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}