resource "aws_instance" "tf_ec2_instance" {
   ami                    = ami-07d2649d67dbe8900
  instance_type          = var.instance_type
  key_name               = "terraform-ec2"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.tf_ec2_sg.id]  # Use tf_ec2_sg security group
  subnet_id              = aws_subnet.tf_public_subnet_1.id    # EC2 instance in public subnet
  depends_on             = [
    aws_db_instance.tf_rds_instance,
    aws_s3_object.tf_s3_object
  ]


  user_data = <<-EOF
            #!/bin/bash

            # Update and install dependencies
            sudo apt update -y
            sudo apt install -y git curl 

            # Install Node.js and npm correctly (use NodeSource)
            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
            sudo apt install -y nodejs

            # Ensure /home/ubuntu exists
            sudo mkdir -p /home/ubuntu

            # Git clone the repository
            sudo git clone https://github.com/shashidas95/terraform-aws-projects.git /home/ubuntu/terraform-aws-projects
            cd /home/ubuntu/terraform-aws-projects/nodejs-mysql

            # Check Ownership and Permissions
            sudo chown -R ubuntu:ubuntu /home/ubuntu/terraform-aws-projects

            # Switch to ubuntu user and set up environment
            sudo -u ubuntu bash -c '
            cd /home/ubuntu/terraform-aws-projects/nodejs-mysql

            # Create .env file with placeholder environment variables
            echo "DB_HOST=${local.rds_endpoint}" > .env
            echo "DB_USER=${aws_db_instance.tf_rds_instance.username}" >> .env
            echo "DB_PASS=${aws_db_instance.tf_rds_instance.password}" >> .env
            echo "DB_NAME=${aws_db_instance.tf_rds_instance.db_name}" >> .env
            echo "TABLE_NAME=users" >> .env
            echo "PORT=3000" >> .env

            # Install dependencies
            npm install

            # Start the application
            nohup npm start &
            '  
  EOF

  user_data_replace_on_change = true

  tags = {
    Name = var.app_name
  }
}

