# Safe to commit — no secrets here
aws_region = "us-east-1"
environment = "dev"

vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.15.0/24", "10.0.16.0/24"]

db_identifier         = "myapp-dev-db"
db_name               = "myappdb"
db_engine             = "mysql"
db_engine_version     = "8.0"
db_instance_class     = "db.t3.micro"
db_allocated_storage  = 20
db_multi_az           = false

# db_master_username and db_master_password intentionally NOT set here
# supply them via: export TF_VAR_db_master_username=... / TF_VAR_db_master_password=...