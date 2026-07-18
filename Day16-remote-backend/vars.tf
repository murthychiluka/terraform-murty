
variable "state_bucket_name" {
  type    = string
  default = "murthy143143143"  # must be globally unique
}

variable "lock_table_name" {
  type    = string
  default = "terraform-state-lock"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}