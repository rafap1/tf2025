
## Create instance - will use defaults for parameters not specified (e.g. VPC, security group)
resource "aws_instance" "server1" {
  ami           = data.aws_ami.ubuntu_24_04_x86.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.sec_web.id]

  tags = {
    Name = "vm-${local.name_suffix}-1"
  }

  root_block_device {
    volume_size = 20
  }

}

resource "aws_ebs_volume" "data_volume" {
  availability_zone = aws_instance.server1.availability_zone
  size              = 50
  type              = "gp3"

  tags = {
    Name = "data-volume-${local.name_suffix}"
  }
}

resource "aws_volume_attachment" "data_volume_attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data_volume.id
  instance_id = aws_instance.server1.id
}



## Data sources to identify the default vpc and its subnets
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc


resource "aws_security_group" "sec_web" {
  vpc_id = data.aws_vpc.def_vpc.id
  name   = "sec-web-${local.name_suffix}"

  ingress {
    description = "Ping from specific addresses"
    from_port   = 8 # ICMP Code 8 - echo  (0 is echo reply)
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = var.sec_allowed_external
  }

  ingress {
    description = "TCP Port 80 from specific addresses"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sec_allowed_external
  }

  ingress {
    description = "Allow TCP for special port from specific addresses"
    from_port   = var.special_port
    to_port     = var.special_port
    protocol    = "tcp"
    cidr_blocks = var.sec_allowed_external
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sec-web-${local.name_suffix}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

