provider "aws" {
}

resource "aws_vpc" "name" {
    cidr_block = "10.1.0.0/16"
    tags = {
      name = "dev_vpc"
    }
}
resource "aws_subnet" "name" {
  vpc_id = "aws_vpc.name.id"
  cidr_block = "10.9.0.0/24"
  tags = {
    Name = "Aadvisubnet"
  }
  
}