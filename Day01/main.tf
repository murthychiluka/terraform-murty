
resource "aws_vpc" "name" {
    cidr_block = "10.1.0.0/16"
    tags = {
      name = "dev_vpc"
    }
}
