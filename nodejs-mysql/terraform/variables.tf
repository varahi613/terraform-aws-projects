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
variable "key_name" {
  type = string
  default = "terraform-ec2-key"
}

variable "db_username" {
  description = "The username for the MySQL database"
  type        = string
}

variable "db_password" {
  description = "The password for the MySQL database"
  type        = string
  sensitive   = true  # Mark as sensitive to avoid logging the password
}