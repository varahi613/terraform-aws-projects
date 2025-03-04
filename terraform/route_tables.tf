resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sas_igw"
  }
}
resource "aws_route_table" "tf_route_table" {
  vpc_id = aws_vpc.main.id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
tags = {
    Name = "sas_route_table"
  }
}
resource "aws_route_table_association" "tf_rta_pub_sub_1" {
  route_table_id = aws_route_table.tf_route_table.id
  subnet_id      = aws_subnet.tf_public_subnet_1.id
}

resource "aws_route_table_association" "tf_rta_pub_sub_2" {
  route_table_id = aws_route_table.tf_route_table.id
  subnet_id      = aws_subnet.tf_public_subnet_2.id
}
