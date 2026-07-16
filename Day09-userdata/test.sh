#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd 
sudo yum install -y python3
sudo yum install git -y
echo "<h1>Hello, World Murthy!</h1>" > var/www/html/index.html