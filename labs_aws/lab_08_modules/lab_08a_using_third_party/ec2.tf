
## Create instance - will use defaults for parameters not specified (e.g. VPC, security group)
resource "aws_instance" "server_pub" {
  ami           = data.aws_ami.ubuntu_24_04_x86.id
  instance_type = var.instance_type
  subnet_id     = module.vpc_one.public_subnets[0] ## Single VM - select a specific subnet
  tags = {
    Name = "vm-pub-${local.name_suffix}"
  }
}



resource "aws_instance" "server_priv" {
  count         = local.num_pub_subnets
  ami           = data.aws_ami.ubuntu_24_04_x86.id
  instance_type = var.instance_type
  subnet_id     = module.vpc_one.public_subnets[count.index]
  tags = {
    Name = "vm-priv-${local.name_suffix}-${count.index}"
  }
}