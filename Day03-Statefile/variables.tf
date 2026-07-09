variable "ami" {
    description = "passing the ami value"
    default = ""
    type = string

}
variable "instance_type" {
    default = ""
    type = string
}   
variable "tags" {
    default = ""
    type = string
}