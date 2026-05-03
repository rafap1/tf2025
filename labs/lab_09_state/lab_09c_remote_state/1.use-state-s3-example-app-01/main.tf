


resource "aws_instance" "test1" {
  ami                    = data.aws_ami.amazon_linux2_kernel_5.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.def_vpc_subnets.ids[0]
  vpc_security_group_ids = [aws_security_group.sec_web.id]
  # key_name               = var.key_name
  tags = {
    Name = "test-${local.name_suffix}"
  }
}


# Security group for web server in public subnet 

resource "aws_security_group" "sec_web" {
  vpc_id = data.aws_vpc.def_vpc.id
  name   = "sec-web-${local.name_suffix}"
  ingress {
    description = "Temp for testing - SSH from specific addresses"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sec_allowed_external
  }
  ingress {
    description = "Ping from specific addresses"
    from_port   = 8 # ICMP Code 8 - echo  (0 is echo reply)
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = var.sec_allowed_external
    # security_groups = [aws_security_group.sec_alb.id]
  }

  ingress {
    description = "TCP Port 5000 from specific addresses"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sec_allowed_external
    # security_groups = [aws_security_group.sec_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sec-web"
  }

  lifecycle {
    create_before_destroy = true
  }
}



