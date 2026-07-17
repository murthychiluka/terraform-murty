

resource "aws_instance" "name" {
    ami           = data.aws_ami.name.id
    instance_type = var.instance_type
    subnet_id     = aws_subnet.public_1b.id
    associate_public_ip_address = true
    tags = {
        Name = var.tags["Name3"]
    }
}

resource "aws_vpc" "name" {
    cidr_block         = var.cidr_block
    enable_dns_support = true
    tags = {
        Name = var.tags["Name1"]
    }
}

resource "aws_subnet" "public_1b" {
    vpc_id            = aws_vpc.name.id
    cidr_block        = var.subnet_cidr_block
    availability_zone = var.availability_zone
    tags = {
        Name = var.tags["Name2"]
    }
}