provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "web_sg" {
  name = "web_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-019715e0d74f695be"
  instance_type = "t2.micro"

  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Ganesh DevOps Project 🚀</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Terraform-Jenkins-EC2"
  }
}
