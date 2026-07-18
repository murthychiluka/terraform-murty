variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.0.12.0/24", "10.0.22.0/24"]
}

variable "vpc_name" {
  type    = string
  default = "my-vpc"
}
