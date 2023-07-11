#create EC2 instance
resource "aws_instance" "instance1" {
  ami                    = var.amiID # AMI ID
  instance_type          = "t2.micro"
  subnet_id              = var.subnet-pri
  associate_public_ip_address = var.status-sub
  key_name               = "Elghaly"
  tags = {
    Name = var.name-instance
  }

  vpc_security_group_ids = [var.sec-id]

  provisioner "local-exec" {
  command = "echo private-ip ${self.private_ip} >> all_ips.txt"
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "Hello, ITI! This was created by Ahmed Elghaly from private subnet." | sudo tee /var/www/html/index.html
    sudo systemctl restart httpd
  EOF


}

