#create internet gateway:
resource "aws_internet_gateway" "gateway" {
  vpc_id = var.ig-vpc-id
  tags = {
    Name = var.name
  }
}

