variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_name" {
  type    = string
  default = "myapp-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "key_name" {
  type    = string
  default = null
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "backend_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "backend_instance_count" {
  type    = number
  default = 2
}

variable "frontend_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "frontend_instance_count" {
  type    = number
  default = 2
}

variable "domain_name" {
  type    = string
  default = "murthydevops.online"
}

variable "db_master_username" {
  type      = string
  sensitive = true
}

variable "db_master_password" {
  type      = string
  sensitive = true
}