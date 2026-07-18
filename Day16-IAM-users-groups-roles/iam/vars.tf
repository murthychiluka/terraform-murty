variable "environment" {
  type    = string
  default = "dev"
}

variable "developer_users" {
  type        = list(string)
  description = "List of usernames to create in the developers group"
  default     = ["alice", "bob"]
}

variable "readonly_users" {
  type        = list(string)
  description = "List of usernames to create in the readonly group"
  default     = ["viewer1"]
}

variable "force_destroy" {
  type        = bool
  description = "Allow user deletion even with access keys attached"
  default     = true
}