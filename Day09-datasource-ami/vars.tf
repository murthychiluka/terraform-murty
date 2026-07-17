variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = ""
}
variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {
    Name1 = ""
    Name2 = ""
  }
}

variable "instance_type" {
  description = "The type of instance to use for the EC2 instance"
  type        = string
  default     = ""
}
variable "availability_zone" {
  description = "The availability zone for the subnet"
  type        = string
  default     = ""
}
# variable "vpc_id" {
#   description = "The ID of the VPC to create the subnet in"
#   type        = string
#   default     = ""
# }