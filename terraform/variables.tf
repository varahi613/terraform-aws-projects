variable "ami_id" {
 type = string
 default = "ami-07d2649d67dbe8900"
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
  default = "vpc-00a0e3c64adf1f8f6"
}
variable "key_name" {
  type = string
  default = "terraform-ec2"
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
