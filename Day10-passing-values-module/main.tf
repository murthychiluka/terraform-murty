module "ec2" {
    source = "../Day10-modules-ec2"
    ami_id = "ami-0cca150d127c2216f"
    instance_type = "t3.micro"
    tags = "MyInstance"
    }

