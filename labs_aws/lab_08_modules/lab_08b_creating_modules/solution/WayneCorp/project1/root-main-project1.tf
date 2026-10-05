## NOTE:  we call this file "root-main.tf" for illustration purposes only. 
##     to help students distinguish it from the main.tf file in modules


## Create a VPC using module
module "my_web_vpc" { ## We could call this "pepe" :-)
  source            = "../modules/aws-web-vpc"
  vpc_name          = var.project
  subnet_name       = "${var.project}-subnet"
  vpc_cidr_block    = var.vpc_cidr
  subnet_cidr_block = var.subnet_cidr

}


## Note references to outputs of module my_web_vpc
module "web1" {
  source            = "../modules/aws-web-server-instance"
  os                = var.server_os
  ec2_instance_type = var.ec2_instance_type
  ec2_instance_name = "web-1-${local.name_suffix}"

  vpc_id        = module.my_web_vpc.vpc_id
  subnet_id     = module.my_web_vpc.subnet_id
  sec_group_ids = [module.my_web_vpc.web_sec_group_id]
}

## Note references to outputs of module my_web_vpc
module "web2" {
  source            = "../modules/aws-web-server-instance"
  os                = "amazon_linux"
  ec2_instance_name = "web-2-${local.name_suffix}"
  ec2_instance_type = var.ec2_instance_type
  vpc_id            = module.my_web_vpc.vpc_id
  subnet_id         = module.my_web_vpc.subnet_id
  sec_group_ids     = [module.my_web_vpc.web_sec_group_id]
}