variable "identifier" {
  type        = string
  description = "Unique identifier for the RDS instance"
}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 100
}

variable "db_name" {
  type = string
}

variable "master_username" {
  type      = string
  sensitive = true
}

variable "master_password" {
  type      = string
  sensitive = true
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnets for the DB subnet group"
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security groups allowed to connect to RDS (e.g. EC2 app tier SG)"
  default     = []
}

variable "port" {
  type    = number
  default = 3306
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "storage_encrypted" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}