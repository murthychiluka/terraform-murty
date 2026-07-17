data "aws_ami" "name" {
    most_recent = true
    owners = [ "amazon" ]
    filter {
        name = "name"
        values = [ "amzn2-ami-hvm-*-gp2" ]
    }
    filter {
        name = "root-device-type"
        values = [ "ebs" ]
    }
    filter {
        name = "virtualization-type"
        values = [ "hvm" ]
    }
    filter {
        name = "architecture"
        values = [ "x86_64" ]
    }

}
/* Removed data lookup for subnet — using managed aws_subnet.public_1b instead. */