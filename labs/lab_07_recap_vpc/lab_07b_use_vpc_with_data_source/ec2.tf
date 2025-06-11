## EC2 instances with ubuntu AMI read from data sources
## Definition of instance uses private subnet id from data sources  
resource "aws_instance" "private_vm" {
  count         = var.num_vms
  ami           = data.aws_ami.ubuntu_24_04_x86.id
  instance_type = var.instance_type

  subnet_id = element(data.aws_subnets.private_subnets.ids, count.index)
  # subnet_id = data.aws_subnets.private_subnets.ids[count.index % length(data.aws_subnets.private_subnets.ids)]

  tags = {
    Name = "vm-${local.name_suffix}-${count.index + 1}"
  }
}