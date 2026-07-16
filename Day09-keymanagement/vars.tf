variable "instance_type" {
  description = "Type of instance to launch"
  type        = string
  default     = "t3.micro"
}
variable "ami_id" {
  description = "AMI ID to use for the instance"
  type        = string
  default     = "ami-0cca150d127c2216f"
}