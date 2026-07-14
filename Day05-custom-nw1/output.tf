output "public_IP" {
  value = aws_instance.web.public_ip
}

output "private_IP" {
  value = aws_instance.private.private_ip
}
output "availability_zone" {
  value = aws_instance.private.availability_zone
}
output "vpc_id" {
  value = aws_vpc.name.id
}
output "public_subnet_id" {
  value = aws_subnet.public.id
}
output "private_subnet_id" {
  value = aws_subnet.private.id
}