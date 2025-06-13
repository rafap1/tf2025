
# ### ======================================= start STEP 1 (security group) ==================================
# resource "aws_security_group" "sec_web" {
#   vpc_id = data.aws_vpc.def_vpc.id
#   name   = "sec-web-${local.name_suffix}"

#   ingress {
#     description = "Ping from specific addresses"
#     from_port   = 8 # ICMP Code 8 - echo  (0 is echo reply)
#     to_port     = 0
#     protocol    = "icmp"
#     cidr_blocks = var.sec_allowed_external
#   }

#   ingress {
#     description = "TCP Port 80 from specific addresses"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = var.sec_allowed_external
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "sec-web-${local.name_suffix}"
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# import {
#   to = aws_security_group.sec_web
#   id = "sg-xxxxxxx"

# }
# # ### ======================================= end STEP 1 (security group) ==================================

# # ### ======================================= start STEP 2 (single instance)==================================
# resource "aws_instance" "example_1" {
#   ami                    = data.aws_ami.ubuntu_24_04_x86.id
#   instance_type          = "t3.nano"
#   vpc_security_group_ids = [aws_security_group.sec_web.id]

#   root_block_device {
#     volume_size = 10
#     volume_type = "gp3"
#   }

#   tags = {
#     Name = "test-${local.name_suffix}-1"
#   }
# }

# import {
#   to = aws_instance.example_1
#   id = "i-aaaaaa"
# }
# ### ======================================= end STEP 2 (single instance ) ==================================


# ### ============================= start STEP 3 (group of instances - for_each)==================================

# resource "aws_instance" "example" {
#   for_each = var.ec2_instances

#   ami                    = data.aws_ami.ubuntu_24_04_x86.id
#   instance_type          = each.value.instance_type
#   vpc_security_group_ids = [aws_security_group.sec_web.id]

#   root_block_device {
#     volume_size = each.value.disk_size_gb
#     volume_type = each.value.disk_type
#   }

#   tags = {
#     Name = "${each.key}-${local.name_suffix}"
#     cost_center = each.value.cost_center
#   }
# }



### Define the mapping as a local value
# locals {
#   instance_mappings = {
#     "web-01" = "i-xxxxx"
#     "web-02" = "i-yyyyy"
#     "app-01" = "i-zzzzz"
#     "app-02" = "i-zzzzz"
#   }
# }

## Single import block with for_each
# import {
#   for_each = local.instance_mappings
  
#   to = aws_instance.example[each.key]
#   id = each.value
# }

# ### ============================= end  STEP 3 (group of instances - for_each)==================================
