locals {
  server_ami_id = {
    ubuntu       = data.aws_ami.ubuntu_22_04.id
    amazon_linux = data.aws_ami.amazon_linux2_kernel_5.id
  }
}

resource "aws_instance" "web_server_instance" {
  ami                    = local.server_ami_id[var.os]
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = var.sec_group_ids
  subnet_id              = var.subnet_id

  tags = {
    Name = var.ec2_instance_name
  }
}

