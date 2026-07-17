output "vpcID" {
	value = aws_vpc.name.id
  
}
output "subnetID" {
	value = aws_subnet.public_1b.id
}
output "instanceID" {
value = aws_instance.name.id
}
output "instancePublicIP" {
value = aws_instance.name.public_ip
}
output "instancePrivateIP" {
value = aws_instance.name.private_ip
}
output "instanceState" {
value = aws_instance.name.instance_state
}
