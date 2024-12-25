resource "aws_instance" "tf_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = "terraform-ec2-key"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.tf_ec2_sg.id]
  depends_on = [ aws_s3_object.tf_s3_object ]
  user_data = <<-EOF
            #!/bin/bash

             # Update and install dependencies
             sudo apt update -y
             sudo apt install -y git nodejs npm

             # Ensure the /home/ubuntu directory exists
             # sudo mkdir -p /home/ubuntu
             # sudo chown ubuntu:ubuntu /home/ubuntu
            

             # Git clone the repository
             git clone https://github.com/verma-kunal/nodejs-mysql.git /home/ubuntu/nodejs-mysql
             cd /home/ubuntu/nodejs-mysql

            # Check Ownership and Permissions:
            sudo chown -R ubuntu:ubuntu /home/ubuntu/nodejs-mysql

             # Create .env file with placeholder environment variables
            echo "DB_HOST=${local.rds_endpoint}" | sudo tee .env
            echo "DB_USER=${aws_db_instance.tf_rds_instance.username}" | sudo tee -a .env
            echo "DB_PASS=${aws_db_instance.tf_rds_instance.password}" | sudo tee -a .env
            echo "DB_NAME=${aws_db_instance.tf_rds_instance.db_name}" | sudo tee -a .env
            echo "TABLE_NAME=users" | sudo tee -a .env
            echo "PORT=3000" | sudo tee -a .env

             # Install dependencies and start the server
             npm install

            EOF
  user_data_replace_on_change = true
  tags = {
    Name = var.app_name
  }
}
resource "aws_security_group" "tf_ec2_sg" {
  name        = "Nodejs-server-sg"
  description = "Allow Http and ssh"
  vpc_id      = var.vpc_id //default vpc id

    ingress {
    description = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] //allow from all ips
  }
    ingress {
    description = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description = "TCP"
    from_port        = 3000 //for nodejs
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description      = "MySQL"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] // allow from all IPs
  }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
output "instance_public_ip" {
     value = aws_instance.tf_ec2_instance.public_ip
   }

output "instance_id" {
     value = aws_instance.tf_ec2_instance.id
   }
output "ssh_to_ec2_instance" {
  value = "ssh -i ~/.ssh/terraform-ec2-key.pem ubuntu@${aws_instance.tf_ec2_instance.public_ip}"
}