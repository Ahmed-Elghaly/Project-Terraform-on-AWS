#create routing table:
resource "aws_route_table" "rtable" {
  vpc_id = var.vpc-rid
  tags = { 
    Name = var.name-rt
  }
}

#create route
resource "aws_route" "route" {
  route_table_id         = aws_route_table.rtable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.gtw-id
}

