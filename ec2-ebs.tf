provider "aws" {
  region = "ap-south-1"
}

# -----------------------------
# EC2 Instance
# -----------------------------
resource "aws_instance" "demo_ec2" {
  ami           = "ami-019715e0d74f695be"
  instance_type = "t3.micro"
  key_name      = "siddhesh-key-pair"

  availability_zone = "ap-south-1a"

  vpc_security_group_ids = ["sg-05c75c81969af1873"]

  user_data = <<-EOF
#!/bin/bash
apt update -y
apt install -y nginx
systemctl start nginx
systemctl enable nginx
EOF

  tags = {
    Name = "MyEC2Instance"
  }
}

# -----------------------------
# EBS Volume
# -----------------------------
resource "aws_ebs_volume" "demo_ebs" {
  availability_zone = "ap-south-1a"
  size              = 30
  type              = "gp3"
  iops              = 3000
  throughput        = 125

  tags = {
    Name = "MyEBSVolume"
  }
}

# -----------------------------
# Attach EBS to EC2
# -----------------------------
resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.demo_ebs.id
  instance_id = aws_instance.demo_ec2.id
}

# -----------------------------
# Output public IP
# -----------------------------
output "ec2_public_ip" {
  value = aws_instance.demo_ec2.public_ip
}
