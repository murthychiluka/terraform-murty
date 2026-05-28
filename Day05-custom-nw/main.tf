#create VPC
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "Dev-vpc"
    }
    
}
#create Subnet
resource "aws_subnet" "name" {
    vpc_id = "aws_vpc.name.id"
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
      "Name" = "custom-sub-1-public"
    }
    
}
 
resource "aws_subnet" "name1" {
    vpc_id = "aws_vpc.name.id"
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
      "Name" = "cust-sub-2"
    }
    
}

#create IG
resource "aws_internet_gateway" "name" {
    vpc_id = "aws_vpc.name.id"
    
}
#create Route table
resource "aws_route_table" "name" {
    vpc_id = "aws_vpc.name.id"
  route  {
    cidr_block = "10.0.0.0/16"
    gateway_id = "aws_internet_gateway.name.id"
          

    }    
    tags = {
      "Name" = "Public-RT"
    }
  } 
  

# create subnet association
resource "aws_route_table_association" "name" {
    subnet_id = "aws_subnet.name.id"
    route_table_id = "aws_route_table.name.id"
    
}
#resource "aws_route_table_association" "name1" {
    #route_table_id = "aws_route_table.name.id"
   # subnet_id = "aws_subnet.name1.id" }
    

     
#create SG

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
    
#create server
resource "aws_instance" "name" {
    instance_type = "t3.micro"
    ami = "ami-0cca150d127c2216f"
    subnet_id = "aws_subnet.name.id"
    associate_public_ip_address = true
    vpc_security_group_ids = [ "aws_security_group.dev_sg.id" ]
    
}

# create EIP
#Create NAT
#Create RT and edit routes
#route table associatins