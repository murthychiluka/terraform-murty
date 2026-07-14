variable "instance_type" {
  type = map(string)

  default = {
    dev  = "t3.micro"
    test = "t2.small"
    prod = "t3.medium"
  }
}


 