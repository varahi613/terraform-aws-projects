resource "aws_subnet" "tf_public_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_customer_owned_ip_on_launch = true
  tags = {
    Name = "public subnet"
  }
}

  resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"     # First private subnet
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false            # No public IP

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"     # Second private subnet
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false            # No public IP

  tags = {
    Name = "private-subnet-2"
  }
}


