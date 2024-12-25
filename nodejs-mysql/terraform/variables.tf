variable "ami_id" {
 type = string
 default = "ami-0e2c8caa4b6378d8c"
 description = "ami image"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "app_name" {
 type = string
 default = "Nodejs-Server"
  
}
variable "vpc_id" {
  type = string
  default = "vpc-049a9c622eddd0b40"
}