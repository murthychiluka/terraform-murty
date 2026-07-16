resource "aws_db_instance" "default" {
  allocated_storage = 20
  db_name           = "mydb"
  identifier        = "rds-test"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  username          = "admin"
  #manage_master_user_password = true #rds and secret manager manage this password
  password             = "Cloud123"
  db_subnet_group_name = aws_db_subnet_group.sub_grp.name
  parameter_group_name = "default.mysql8.0"

  # Enable backups and retention
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window = "02:00-03:00" # Daily backup window (UTC)

  # Enable monitoring (CloudWatch Enhanced Monitoring)
  # monitoring_interval      = 60  # Collect metrics every 60 seconds
  #monitoring_role_arn      = aws_iam_role.rds_monitoring.arn

  # Enable performance insights
  # performance_insights_enabled          = true
  # performance_insights_retention_period = 7  # Retain insights for 7 days

  # Maintenance window
  maintenance_window = "sun:04:00-sun:05:00" # Maintenance every Sunday (UTC)

  # Enable deletion protection (to prevent accidental deletion)
  deletion_protection = true

  # Skip final snapshot
  skip_final_snapshot = true
  depends_on          = [aws_db_subnet_group.sub_grp] # Ensure subnet group is created before the DB instance

}

# # IAM Role for RDS Enhanced Monitoring
# resource "aws_iam_role" "rds_monitoring" {
#   name = "rds-monitoring-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "monitoring.rds.amazonaws.com"
#       }
#     }]
#   })
# }

#IAM Policy Attachment for RDS Monitoring
# resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
#   role       = aws_iam_role.rds_monitoring.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
# }


# resource "aws_db_subnet_group" "sub-grp" {
#   name       = "mycutsubnet"
#   subnet_ids = ["subnet-07395049b5d813a79", "subnet-0d2209bc56450d423"]

#   tags = {
#     Name = "My DB subnet group"
#   }
# }


resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev"
  }

}
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.18.0/24"
  availability_zone = "us-east-1a"

}
resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.19.0/24"
  availability_zone = "us-east-1b"

}

resource "aws_security_group" "dev_sg" {
  description = "allow"
  vpc_id      = aws_vpc.name.id
  tags = {
    Name = "dev_sg"
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    description = "all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_subnet_group" "sub_grp" {
  name       = "mydbsubnet"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

####### with data source ########### here we can use existing subnet to create db subnet group with that existing subnet
# data "aws_subnet" "subnet_1" {
#   filter {
#     name   = "tag:Name"
#     values = ["subnet-1"]
#   }
# }

# data "aws_subnet" "subnet_2" {
#   filter {
#     name   = "tag:Name"
#     values = ["subnet-2"]
#   }
# # }
# resource "aws_db_subnet_group" "sub_grp" {
#   name       = "mycutsubnet"
#   subnet_ids = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]

#   tags = {
#     Name = "My DB subnet group"
#   }
# }



# Create replica of the above db instance  #your task 

 resource "aws_db_instance" "replica" {
  identifier = "my-read-replica"

  replicate_source_db = aws_db_instance.default.identifier

  instance_class = "db.t3.micro"

   publicly_accessible = false

   db_subnet_group_name   = aws_db_subnet_group.sub_grp.name
   vpc_security_group_ids = [aws_security_group.dev_sg.id]

   skip_final_snapshot = true

   depends_on = [aws_db_instance.default]
 }
 # Redis creation is not free in free tier

 resource "aws_elasticache_subnet_group" "redis" {
  name       = "redis-subnet-group"
  subnet_ids = [
    aws_subnet.subnet_1.id,
    aws_subnet.subnet_2.id
  ]
}

#security group for redis
resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  description = "Redis Security Group"
  vpc_id      = aws_vpc.name.id

  ingress {
    description     = "Redis Access"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
    #Replace aws_security_group.ec2_sg.id with your EC2 application's(backend) security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-sg"
  }
}
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "my-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379

  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redis_sg.id]

  parameter_group_name = "default.redis7"

  tags = {
    Name = "my-redis"
  }
}
output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_port" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].port
}
    
