#create route table association for public subnet
resource "aws_route_table_association" "asso" {
  subnet_id      = var.sub-id
  route_table_id = var.rt-id
  #route_table_id = aws_route_table.rtable1.id
}
