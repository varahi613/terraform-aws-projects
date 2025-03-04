resource "aws_alb" "tf_web_alb" {
  name               = "tf-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf_ec2_sg.id]
  subnets            = [aws_subnet.tf_public_subnet_1.id, aws_subnet.tf_public_subnet_2.id]
  enable_deletion_protection = false
  tags = {
    Name = "tf web alb"
  }
}
