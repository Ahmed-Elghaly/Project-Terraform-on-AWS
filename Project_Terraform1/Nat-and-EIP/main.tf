# Create EIP for NAT gateway
resource "aws_eip" "nat" {
  vpc = true
}

# Create NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  #subnet_id     = aws_subnet.subnet1.id
  subnet_id = var.subnet-id 
}

