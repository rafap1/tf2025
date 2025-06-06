
resource "aws_instance" "example" {
  for_each = var.ec2_instances

  ami                         = data.aws_ami.ubuntu_24_04_x86.id
  instance_type               = each.value.instance_type
  vpc_security_group_ids      = [aws_security_group.sec_web.id]

  root_block_device {
    volume_size = each.value.disk_size_gb     
    volume_type = "gp3"       # Use gp3 for modern general-purpose SSD
  }

  tags = {
    Name = "${local.name_suffix}-each.key"
  }
}



