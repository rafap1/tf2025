
## Create a VPC using module
module "my_web_vpc" { ## We could call this "pepe" :-)
  #  source            = "../modules/aws-web-vpc"
  source = "github.com/rpgd60/tfcourse-modules//web-modules/aws-web-vpc?ref=v1.0.2"

  vpc_name          = var.project
  subnet_name       = "${var.project}-subnet"
  vpc_cidr_block    = var.vpc_cidr
  subnet_cidr_block = var.subnet_cidr

}

## Note references to outputs of module my_web_vpc
module "web1" {
  #  source            = "../modules/aws-web-server-instance"
  # source            = "github.com/rpgd60/tfcourse-modules//web-modules/aws-web-server-instance"
  # Note below: "ref" in lower case
  source = "github.com/rpgd60/tfcourse-modules//web-modules/aws-web-server-instance?ref=v1.0.2"

  os                = var.server_os
  ec2_instance_type = var.ec2_instance_type
  ec2_instance_name = "web-1-${local.name_suffix}"

  vpc_id        = module.my_web_vpc.vpc_id
  subnet_id     = module.my_web_vpc.subnet_id
  sec_group_ids = [module.my_web_vpc.web_sec_group_id]
}

## Note references to outputs of module my_web_vpc
module "web2" {
  #  source            = "../modules/aws-web-server-instance"
  source            = "github.com/rpgd60/tfcourse-modules//web-modules/aws-web-server-instance?ref=v1.0.2"
  os                = "amazon_linux"
  ec2_instance_name = "web-2-${local.name_suffix}"
  ec2_instance_type = var.ec2_instance_type
  vpc_id            = module.my_web_vpc.vpc_id
  subnet_id         = module.my_web_vpc.subnet_id
  sec_group_ids     = [module.my_web_vpc.web_sec_group_id]
}
