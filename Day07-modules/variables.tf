variable "ami_id" {
    description = "The AMI ID to use for the instance"
    type        = string
}

variable "instance_type" {
    description = "The instance type to use"
    type        = string
}

variable "tags" {
    description = "A map of tags to assign to the instance"
    type        = map(string)
}
