variable "environment" {
  type    = string
  default = "dev"
}

variable "developer_users" {
  type    = list(string)
  default = ["murthy", "aadvik", "sudeepbala"]
}

variable "readonly_users" {
  type    = list(string)
  default = ["viewer1"]
}