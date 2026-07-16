resource "aws_key_pair" "name" {
    key_name = "my-key"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "name" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = aws_key_pair.name.key_name
    
}