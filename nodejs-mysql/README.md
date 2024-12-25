Automating AWS Infrastructure with Terraform: A Step-by-Step Guide
![Automating AWS Infrastructure with Terraform](./public/images/terraform-aws.png)

/terraform-aws-projects/nodejs-mysql/public/images/terraform-aws.png
In this tutorial, we will automate the creation and management of AWS resources using Terraform, a powerful infrastructure as code (IaC) tool. We will walk through setting up an AWS S3 bucket, uploading objects to it, provisioning an EC2 instance, and even configuring a MySQL RDS database—all with Terraform.
Prerequisites:
AWS account with IAM user credentials (Access Key ID and Secret Access Key).
Terraform installed on your local machine.
AWS Toolkit Extension for VS Code: It simplifies working with AWS services directly from VS Code.

Step 1: Set Up Terraform Environment
First, let's set up the environment for your Terraform project.
1.1 Install AWS Toolkit Extension in VS Code
The AWS Toolkit for VS Code helps you interact with AWS services directly from the VS Code editor. Once installed, you can access services like EC2, Lambda, and S3 right from your editor.
1.2 Configure IAM User Credentials
Make sure your IAM user has programmatic access (access keys) to interact with AWS via Terraform. You’ll need your Access Key and Secret Access Key.
Go to your AWS Management Console.
Navigate to IAM and create a new user with Programmatic access.
Save the Access Key and Secret Key. Store them securely.
1.3 Create a Folder for Terraform Configuration
Create a new folder for your Terraform code:
mkdir terraform
cd terraform
Inside the terraform folder, create a file named provider.tf to configure your AWS provider.
provider "aws" {
region = "us-east-1"
shared_credentials_files = ["~/.aws/credentials"]
profile = "terraform-key"
}
This configuration tells Terraform to use your AWS credentials stored in ~/.aws/credentials and specifies the AWS region.
1.4 Initialize Terraform
Run the following command to initialize the Terraform project:
terraform init
You'll see output like:
Terraform has been successfully initialized!

Step 2: Provision S3 Bucket and Objects
2.1 Create an S3 Bucket
To start provisioning, create a file s3.tf in your Terraform folder:
resource "aws_s3_bucket" "tf_s3_bucket" {
bucket = "my-tf-nodejs-bucket"

tags = {
Name = "sas_nodejs_bucket"
Environment = "Dev"
}
}
Run the following Terraform commands to apply the configuration:
terraform plan
terraform apply
You’ll see output confirming that the S3 bucket has been created:
aws_s3_bucket.tf_s3_bucket: Creation complete after 7s [id=my-tf-nodejs-bucket]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

2.2 Upload Objects to the Bucket
Next, create a resource for uploading files to the S3 bucket. Create a file s3_object.tf:
resource "aws_s3_object" "tf_s3_object" {
bucket = aws_s3_bucket.tf_s3_bucket.bucket
for_each = fileset("../public/images", "\*\*")
key = "images/${each.key}"
  source = "../public/images/${each.key}"
}
This configuration will upload all files from the local directory ../public/images to the S3 bucket under the images/ prefix.
Run the following to apply the changes:
terraform plan
terraform apply
You’ll see output confirming that the objects have been uploaded to the bucket:
aws_s3_object.tf_s3_object["logo.png"]: Creation complete after 1s [id=images/logo.png]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Step 3: Provision an EC2 Instance

3.1 Configure EC2 Instance
Firstly I need key pair for simplify ec2 instant creation.
Make sure you’ve added your EC2 key pair file terraform-ec2-key.pem in the .ssh directory:
chmod 400 ~/.ssh/terraform-ec2-key.pem

We will define a Terraform resource for creating an EC2 instance. The instance will be provisioned using a specific AMI, instance type, and an SSH key for access.
To automate your EC2 instance setup, you can use a user_data script. This script will run upon instance launch and can perform tasks like cloning a Git repository, installing dependencies, and starting your Node.js server.
Add this user_data section in your EC2 resource:
user_data = <<-EOF
#!/bin/bash

             # Update and install dependencies
             sudo apt update -y
             sudo apt install -y git nodejs npm

             # Ensure the /home/ubuntu directory exists
             # sudo mkdir -p /home/ubuntu
             # sudo chown ubuntu:ubuntu /home/ubuntu


             # Git clone the repository
             git clone https://github.com/shashidas95/terraform-aws-projects.git /home/ubuntu/terraform-aws-projects/nodejs-mysql
             cd /home/ubuntu/terraform-aws-projects/nodejs-mysql

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

Run terraform apply to apply the changes and create the EC2 instance. Once the instance is running, it will automatically clone the Git repository and install dependencies.
EC2 creation using user_data with Terraform by the provided code:
resource "aws_instance" "tf_ec2_instance" {
ami = "ami-0e2c8caa4b6378d8c" # Update with the latest Ubuntu AMI ID for your region
instance_type = "t2.micro" # Choose an appropriate instance size
key_name = "terraform-ec2-key" # Your SSH key name
associate_public_ip_address = true
vpc_security_group_ids = [aws_security_group.tf_ec2_sg.id] # Security group associated

depends_on = [ aws_s3_object.tf_s3_object ] # Any dependencies

# User data for instance initialization

user_data = <<-EOF
#!/bin/bash

    # Update and install dependencies
    sudo apt update -y
    sudo apt install -y git nodejs npm

    # Git clone the repository
    git clone https://github.com/verma-kunal/nodejs-mysql.git /home/ubuntu/nodejs-mysql
    cd /home/ubuntu/nodejs-mysql

    # Ensure proper ownership and permissions
    sudo chown -R ubuntu:ubuntu /home/ubuntu/nodejs-mysql

    # Create .env file with database credentials
    echo "DB_HOST=${local.rds_endpoint}" | sudo tee .env
    echo "DB_USER=${aws_db_instance.tf_rds_instance.username}" | sudo tee -a .env
    echo "DB_PASS=${aws_db_instance.tf_rds_instance.password}" | sudo tee -a .env
    echo "DB_NAME=${aws_db_instance.tf_rds_instance.db_name}" | sudo tee -a .env
    echo "TABLE_NAME=users" | sudo tee -a .env
    echo "PORT=3000" | sudo tee -a .env

    # Install dependencies and start the server
    npm install

EOF

user_data_replace_on_change = true # Replaces user data on changes
tags = {
Name = "Nodejs-Server" # EC2 instance name
}
}
Step 3.2: Define the Security Group
Next, we'll define a security group to allow necessary inbound and outbound traffic for the EC2 instance. This includes SSH (port 22), HTTP (port 443), MySQL (port 3306), and the application’s port (3000 for Node.js).
resource "aws_security_group" "tf_ec2_sg" {
name = "Nodejs-server-sg"
description = "Allow Http, SSH, and MySQL"
vpc_id = "vpc-049a9c622eddd0b40" # Specify your default VPC ID

ingress {
description = "TLS from VPC"
from_port = 443
to_port = 443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"] # Allow from all IPs
}

ingress {
description = "SSH"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
description = "TCP for Node.js"
from_port = 3000
to_port = 3000
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
description = "MySQL"
from_port = 3306
to_port = 3306
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"] # Allow from all IPs
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}
Step 4: Output the EC2 Public IP
Finally, we can output the public IP of the EC2 instance, so you can easily SSH into it once it’s created. To retrieve the public IP of your EC2 instance, you can define an output variable:
output "ec2_public_ip" {
value = "ssh -i ~/.ssh/terraform-ec2-key.pem ubuntu@${aws_instance.tf_ec2_instance.public_ip}"
}
This output will allow you to quickly connect to the EC2 instance using the SSH command.

Step 5: (Optional) Set Up RDS Instance
If you also need an RDS MySQL instance, you can provision it with a resource like this:
Planning for creating RDS-MySql with terraform
/\*
rds.tf

1. rds resource
2. security group
   - 3306
     security group => tf_ec2_sg
     cidr block=> [“local ip”]
3. output

\*/

resource "aws_db_instance" "tf_rds_instance" {
allocated_storage = 10
db_name = "shashi_demo"
identifier = "nodejs-rds-mysql"
engine = "mysql"
engine_version = "8.0"
instance_class = "db.t3.micro"
username = "admin"
password = "shashi123"
parameter_group_name = "default.mysql8.0"
skip_final_snapshot = true
publicly_accessible = true
vpc_security_group_ids = [ aws_security_group.tf_rds_sg.id ]
}
resource "aws_security_group" "tf_rds_sg" {
name = "allow_mysql"
description = "Allow mysql traffic"
vpc_id = "vpc-049a9c622eddd0b40" //default vpc id

ingress {
description = "Allow MySQL from EC2"
from_port = 3306
to_port = 3306
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"] //local ip
security_groups = [aws_security_group.tf_ec2_sg.id]// EC2 instance security group ID
}
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}
locals {
rds_endpoint = element(split(":", aws_db_instance.tf_rds_instance.endpoint),0)
}
output "rds_endpoint" {
value = local.rds_endpoint
}
output "rds_username" {
value = aws_db_instance.tf_rds_instance.username
}
output "db_name" {
value = aws_db_instance.tf_rds_instance.db_name
}

Check the database in rds from the ec2 instance
Firstly ssh to the ec2 instance using the command which is given by the output after the ec2 creation:
ssh -i ~/.ssh/terraform-ec2-key.pem ubuntu@98.84.133.184
Then apply the command:
mysql -h nodejs-rds-mysql.cpm2wm4ealfl.us-east-1.rds.amazonaws.com -u admin -p
It will prompt for giving password .
Create database and input data
CREATE DATABASE shashi_demo;

use shashi_demo;

CREATE TABLE users (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL
);

INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO users (name, email) VALUES ('Jane Smith', 'jane@example.com');
INSERT INTO users (name, email) VALUES ('shashikanta ', 'kanta@gmail.com');

Step 6: Run Terraform to Apply Changesterraform planterraform apply
After Terraform finishes provisioning, use the output command to SSH into your EC2 instance.SSH into the instance using the provided public IP. Ensure that the Node.js application is running by accessing the appropriate port (e.g., http://<public_ip>:3000).
This Terraform configuration enables you to automate the creation of EC2 instances, security groups, and the deployment of a Node.js application connected to an RDS MySQL database. By using Terraform, you can maintain reproducibility and consistency in your infrastructure.
Happy Terraforming!

# NodeJs app with MySQL Database

A simple nodejs app connected with mySQL database.

## Getting Started

1. Clone the repo

```bash
git clone https://github.com/verma-kunal/nodejs-mysql.git
cd nodejs-mysql
```

2. Create a `.env` file in root directory and add the environment variables:

```bash
DB_HOST="localhost"
DB_USER="root" # default mysql user
DB_PASS=""
DB_NAME=""
TABLE_NAME=""
PORT=3000
```

> Make sure to create the database and the corresponding table in your mySQL database. 3. Initialize and start the development server:

```bash
npm install
npm run dev
```

![running app](https://github.com/user-attachments/assets/d882c2ec-2539-49eb-990a-3b0669af26b6)
