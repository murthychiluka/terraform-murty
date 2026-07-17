resource "aws_vpc" "name" {
    cidr_block         = "10.0.0.0/16"
    region = "us-east-1"
 tags = {
        Name = "dev-vpc"

}
}
resource "aws_s3_bucket" "name" {
    bucket = "murthy-terraform1435666"
    region = "us-east-1"
    depends_on = [aws_vpc.name]
}