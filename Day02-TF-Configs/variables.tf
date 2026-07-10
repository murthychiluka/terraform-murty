variable "ami_id" {
    description = "passing the ami value"
    default = "ami-0cca150d127c2216f"
    type = string

}
variable "type" {
    default = "t3.micro"
    type = string
}