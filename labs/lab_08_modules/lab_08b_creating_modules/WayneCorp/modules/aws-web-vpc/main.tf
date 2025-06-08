# For sg name randomness
resource "random_id" "sg_suffix" {
  byte_length = 8
}

resource "aws_vpc" "web_server_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "web_server_subnet" {
  vpc_id                  = aws_vpc.web_server_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.aws_az

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_internet_gateway" "web_server_igw" {
  vpc_id = aws_vpc.web_server_vpc.id

  tags = {
    Name = "${var.vpc_name}-${var.igw_name}"
  }
}

resource "aws_route_table" "web_server_rt" {
  vpc_id = aws_vpc.web_server_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_server_igw.id
  }

  tags = {
    Name = "${var.vpc_name}-${var.rt_name}"  }
}

resource "aws_route_table_association" "web_server_rt_association" {
  subnet_id      = aws_subnet.web_server_subnet.id
  route_table_id = aws_route_table.web_server_rt.id
}

resource "aws_security_group" "web_server_sg_name" {
  name        = local.sg_name
  description = "Web security group (created by module)"
  vpc_id      = aws_vpc.web_server_vpc.id

  ingress {
    description      = "Allow traffic on port 80 from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = local.sg_name
  }

  lifecycle {
    create_before_destroy = true
  }
}


