resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt"
  image_id      = ami-07d2649d67dbe8900  # Replace with your AMI ID
  instance_type = "t2.micro"

  tag_specifications {
    resource_type = "instance"
tags = {
    Name = var.app_name
  }
  }
}
