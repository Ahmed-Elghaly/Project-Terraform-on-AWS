#create routing table:
resource "aws_route_table" "rtable-pri" {
  vpc_id = var.vpc-rid-pri
  tags = { 
    Name = var.name-rt-pri
  }
}

#create route
resource "aws_route" "route-pri" {
  route_table_id         = aws_route_table.rtable-pri.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat-id
}

