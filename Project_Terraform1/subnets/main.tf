resource "aws_subnet" "subnents" {
    cidr_block = var.cider-block 
    vpc_id = var.vpc-id
    availability_zone = var.av-zone

    map_public_ip_on_launch = var.status
  tags = {
    Name = var.name
  }

}