resource "aws_autoscaling_group" "tf_auto-scaling_group" {
  desired_capacity = 2
  max_size = 5
  min_size = 1
  vpc_zone_identifier = aws_subnet.tf_public_subnet.id
  launch_template {
    id = aws_launch_template.web_lt.id
    version = "$Latest"
  }

}