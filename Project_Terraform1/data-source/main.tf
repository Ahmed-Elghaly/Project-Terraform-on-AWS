data "aws_ami" "instance_ami" {
  most_recent = true
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  filter {
    name   = "name"
    values = ["al2023-ami-2023.1.20230705.0-kernel-6.1-x86_64"]
  }
  
  owners = ["amazon"]
}

