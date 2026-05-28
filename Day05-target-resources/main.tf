resource "aws_instance" "dev" {
    ami = "ami-0cca150d127c2216f"
    instance_type = "t3.micro"
      tags = {
        "Name" = "dev"
      }

}      

resource "aws_s3_bucket" "name" {
    
 bucket = "my-tf-test-bucke-murthy"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
 #terraform plan -target=aws_s3_bucket.name   
