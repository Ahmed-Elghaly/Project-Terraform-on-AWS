# Create EC2 instance
/*
resource "aws_instance" "public_instance" {
  ami                    = var.AMI_ID
  instance_type          = "t2.micro"
  subnet_id              = var.sub-p-id
  associate_public_ip_address = true
  key_name               = "Elghaly"
  tags = {
    Name = var.name-p
  }
  vpc_security_group_ids = [var.sec-p-id]
  
  provisioner "local-exec" {
  command = "echo private-ip ${self.private_ip} >> all_ips.txt"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"  # or the appropriate username for your AMI
      private_key = file("./Elghaly.pem")
    }
  
    inline = [
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo tee /etc/nginx/conf.d/proxy.conf > /dev/null <<EOF",
      "server {",
      "    listen 80;",
      "    server_name your_domain.com;",
      "",
      "    location / {",
      "        proxy_pass http://private-lb-7a08f0b7367310d2.elb.us-east-1.amazonaws.com;",
      "        proxy_set_header Host $host;",
      "        proxy_set_header X-Real-IP $remote_addr;",
      "    }",
      "}",
      "EOF",
      "sudo service nginx restart",
    ]

  }
}
*/

resource "aws_instance" "public_instance" {
  ami                    = var.AMI_ID
  instance_type          = "t2.micro"
  subnet_id              = var.sub-p-id
  associate_public_ip_address = true
  key_name               = "Elghaly"
  tags = {
    Name = var.name-p
  }
  vpc_security_group_ids = [var.sec-p-id]

  user_data = <<-EOF
    #!/bin/bash

    # Update system packages
    sudo yum update -y

    # Install Nginx
    sudo yum install nginx -y

    # Configure Nginx as a proxy
    sudo tee /etc/nginx/conf.d/proxy.conf > /dev/null <<EOFC
    server {
        listen 80;
        server_name your_domain.com;

        location / {
            proxy_pass http://private-lb-7a08f0b7367310d2.elb.us-east-1.amazonaws.com;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
    }
    EOFC

    # Restart Nginx
    sudo service nginx restart
  EOF

  provisioner "local-exec" {
    command = "echo public-ip ${self.public_ip} >> all_ips.txt"
  }
}
