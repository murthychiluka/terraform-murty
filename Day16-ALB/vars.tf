# --- Variables ---
variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_name" {
  type    = string
  default = "my-alb"
}
variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for HTTPS listener"
}