output "instance_ids" {
  value = aws_instance.web[*].id
}

output "instance_private_ips" {
  value = aws_instance.web[*].private_ip
}