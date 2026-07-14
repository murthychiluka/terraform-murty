

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "Dev-vpc"
    }
    
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.16.0/24"
    availability_zone = "us-east-1a"
    tags = {
      "Name" = "custom-sub-public1"
    }
}
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.17.0/24"
    availability_zone = "us-east-1b"
    tags = {
      "Name" = "cust-Private-sub-1"
    }
}
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    
}
resource "aws_route_table" "Public_RT" {
    vpc_id = aws_vpc.name.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }
  tags = {
      "Name" = "Public-RT"
    }
}
resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.Public_RT.id
}

 resource "aws_security_group" "dev_sg" {
  description = "allow"
  vpc_id      = aws_vpc.name.id
    tags = {
      "Name" = "dev_sg"
    }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
}
    

resource "aws_nat_gateway" "name" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public.id
    tags = {
      "Name" = "nat-gw"
    }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.name.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private_RT.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.name.id

}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_RT.id
}
 
 resource "aws_instance" "web" {
    ami= var.ami_id
    instance_type = var.type
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.dev_sg.id]
    associate_public_ip_address = true
    tags = {
      Name = "Dev-Server"
    }
 }

    resource "aws_instance" "private" {
    ami = var.ami_id
    instance_type = var.type
    subnet_id = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.dev_sg.id]
    tags = {
      Name = "Private-Server"
    }   
    }