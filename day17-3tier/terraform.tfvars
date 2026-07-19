environment          = "dev"
vpc_name             = "myapp-vpc"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

app_port                 = 8080
backend_instance_type    = "t3.micro"
backend_instance_count   = 2
frontend_instance_type   = "t3.micro"
frontend_instance_count  = 2

domain_name = "murthydevops.online"

# db_master_username / db_master_password → set via secrets.auto.tfvars or TF_VAR_*