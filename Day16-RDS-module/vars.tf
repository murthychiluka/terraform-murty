variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"
}

# --- Network ---
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# --- RDS ---
variable "db_identifier" {
  type        = string
  description = "Unique identifier for the RDS instance"
  default     = "myapp-db"
}

variable "db_name" {
  type        = string
  description = "Initial database name"
  default     = "myappdb"
}

variable "db_engine" {
  type        = string
  description = "Database engine"
  default     = "mysql"
}

variable "db_engine_version" {
  type        = string
  description = "Database engine version"
  default     = "8.0"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance size"
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  type        = number
  description = "Initial storage size in GB"
  default     = 20
}

variable "db_multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment"
  default     = false
}

# --- Sensitive — supply via env vars or a gitignored file, NOT this file ---
variable "db_master_username" {
  type        = string
  description = "Master username for RDS"
  sensitive   = true
}

variable "db_master_password" {
  type        = string
  description = "Master password for RDS"
  sensitive   = true
}