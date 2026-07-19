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
variable "enable_nat_gateway" {
  type        = bool
  description = "Create NAT gateway(s) for private subnet internet access"
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "true = one shared NAT gateway (cheaper); false = one per AZ (more resilient)"
  default     = true
}
variable "tags" {
  type    = map(string)
  default = {}
}