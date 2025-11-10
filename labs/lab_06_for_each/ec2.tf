
resource "aws_instance" "example" {
  for_each = var.ec2_instances

  ami                    = data.aws_ami.ubuntu_24_04_x86.id
  instance_type          = each.value.instance_type
  vpc_security_group_ids = [aws_security_group.sec_web.id]

  root_block_device {
    volume_size = each.value.disk_size_gb
    volume_type = each.value.disk_type
  }

  tags = {
    Name        = "${each.key}-${local.name_suffix}"
    cost_center = each.value.cost_center
  }
}

## Individual Instance below is created only for future use in lab 9 (import infrastructure)
resource "aws_instance" "example_1" {
  ami                    = data.aws_ami.ubuntu_24_04_x86.id
  instance_type          = "t3.nano"
  vpc_security_group_ids = [aws_security_group.sec_web.id]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "test-${local.name_suffix}-1"
  }
}

