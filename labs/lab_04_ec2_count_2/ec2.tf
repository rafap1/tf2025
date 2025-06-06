## Create instance - will use defaults for parameters not specified (e.g. VPC, security group)
resource "aws_instance" "server" {
  count = local.ninstances
  ami           = data.aws_ami.amazon_linux2_kernel_5.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.sec_web.id]

  tags = {
    Name = "server-${local.name_suffix}-${var.instance_names[count.index]}"
  }
}



