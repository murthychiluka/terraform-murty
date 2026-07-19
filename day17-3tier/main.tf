
module "vpc" {
  source = "./VPC"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = { Environment = var.environment }
}

# ============================================================
# ALB (public-facing)
# ============================================================

module "alb" {
  source = "./alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_name          = "myapp-alb"
}

# ============================================================
# SECURITY GROUPS — created standalone, breaks circular dependency
# ============================================================

resource "aws_security_group" "frontend_sg" {
  name        = "frontend-nginx-sg"
  description = "Allow HTTP only from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [module.alb.alb_security_group_id]
  }

  ingress {
    description = "SSH within VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "frontend-nginx-sg" }
}

resource "aws_security_group" "backend_sg" {
  name        = "backend-app-sg"
  description = "Allow app port only from nginx frontend tier"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "App port from frontend"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  ingress {
    description = "SSH within VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "backend-app-sg" }
}

# ============================================================
# AMI
# ============================================================

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# ============================================================
# BACKEND APP SERVERS (Tier 2) — created first, no dependency on frontend instances
# ============================================================

resource "aws_instance" "backend" {
  count                  = var.backend_instance_count
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.backend_instance_type
  subnet_id              = module.vpc.private_subnet_ids[count.index % length(module.vpc.private_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y python3
              cat <<'APP' > /home/ec2-user/app.py
              from http.server import BaseHTTPRequestHandler, HTTPServer
              import socket

              class Handler(BaseHTTPRequestHandler):
                  def do_GET(self):
                      self.send_response(200)
                      self.end_headers()
                      self.wfile.write(f"Hello from backend {socket.gethostname()}".encode())

              HTTPServer(("0.0.0.0", ${var.app_port}), Handler).serve_forever()
              APP
              nohup python3 /home/ec2-user/app.py > /var/log/app.log 2>&1 &
              EOF

  tags = { Name = "backend-app-${count.index + 1}" }
}

# ============================================================
# FRONTEND NGINX SERVERS (Tier 1) — references backend private IPs
# This dependency is one-directional: frontend depends on backend,
# backend does NOT depend on frontend instances (only frontend_sg,
# which already exists). No cycle.
# ============================================================

locals {
  upstream_servers = join("\n", [
    for ip in aws_instance.backend[*].private_ip : "    server ${ip}:${var.app_port};"
  ])
}

resource "aws_instance" "frontend" {
  count                  = var.frontend_instance_count
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.frontend_instance_type
  subnet_id              = module.vpc.private_subnet_ids[count.index % length(module.vpc.private_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y nginx
              cat <<'CONF' > /etc/nginx/conf.d/proxy.conf
              upstream backend_app {
              ${local.upstream_servers}
              }

              server {
                  listen 80;
                  location / {
                      proxy_pass http://backend_app;
                      proxy_set_header Host $host;
                      proxy_set_header X-Real-IP $remote_addr;
                  }
              }
              CONF
              rm -f /etc/nginx/conf.d/default.conf
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = { Name = "frontend-nginx-${count.index + 1}" }

  depends_on = [aws_instance.backend]
}

# ============================================================
# ATTACH FRONTEND INSTANCES TO ALB TARGET GROUP
# ============================================================

resource "aws_lb_target_group_attachment" "frontend" {
  count            = var.frontend_instance_count
  target_group_arn = module.alb.target_group_arn
  target_id        = aws_instance.frontend[count.index].id
  port             = 80
}

# ============================================================
# RDS MySQL (Tier 3)
# ============================================================

module "rds" {
  source = "./rds"

  identifier      = "myapp-db"
  db_name         = "myappdb"
  master_username = var.db_master_username
  master_password = var.db_master_password

  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.private_subnet_ids
  allowed_security_group_ids = [aws_security_group.backend_sg.id]

  tags = { Environment = var.environment }
}

# ============================================================
# ROUTE53 — ALB alias
# ============================================================

module "route53" {
  source = "./route53"

  domain_name  = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

# ============================================================
# OUTPUTS
# ============================================================

output "site_url" {
  value = "http://${var.domain_name}"
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "backend_private_ips" {
  value = aws_instance.backend[*].private_ip
}