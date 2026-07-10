#############################
# Variable Block
#############################

variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

#############################
# EC2 Instance
#############################

resource "aws_instance" "web" {
  count = var.env == "prod" ? 3 : 1

  ami           = "ami-0cca150d127c2216f"   # Replace with your AMI ID
  instance_type = "t3.micro"

  tags = {
    Name        = "${var.env}-server-${count.index + 1}"
    Environment = var.env
  }
}