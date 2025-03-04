resource "aws_alb" "tf_web_alb" {
  name = "tf_web_alb"
  internal = false
  load_balancer_type = application
  security_groups = [aws_security_groups.tf_ec2_sg.id]
  subnets = [aws_subnet.tf_public_subnet]
  enable_deletion_protection = false
  tags = {
    Name = tf_web_alb
  }
}