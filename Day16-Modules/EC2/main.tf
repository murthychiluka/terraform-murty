# --- Variables ---




# --- Latest Amazon Linux 2023 AMI ---



# --- Security Group for EC2 (only allow traffic from ALB) ---
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-alb-backend-sg"
  description = "Allow HTTP traffic only from ALB, and SSH for admin access"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # tighten this to your IP in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-alb-backend-sg"
  }
}

# --- EC2 Instances ---
resource "aws_instance" "web" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server-${count.index + 1}"
  }
}

# --- Attach Instances to ALB Target Group ---
resource "aws_lb_target_group_attachment" "web" {
  count            = var.instance_count
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

# --- Outputs ---

