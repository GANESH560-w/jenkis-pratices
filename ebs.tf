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

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.demo_ebs.id
  instance_id = aws_instance.demo_ec2.id
}
