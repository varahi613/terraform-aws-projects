resource "aw_route_tables" "tf_public_route_table" {
  vpc_id= aws_vpc.main.id
  route={
   cidr_block="10.0.0.0/0"
   gateway_id= aws_internet_gateway.main.id
  }
  tags = {
    Name = "public-route-table"
  }
}