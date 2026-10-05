## NOTE:  we call this file "root-main" for illustration purposes only. 
##     to help students distinguish it from the main.tf file in modules


module "vpc_proj2" {
  #  source            = "../modules/aws-web-vpc"
  source            = "github.com/rpgd60/tfcourse-modules//web-modules/aws-web-vpc"
  vpc_name          = var.project
  subnet_name       = "${var.project}-subnet"
  aws_az            = "${var.region}c"
  vpc_cidr_block    = var.vpc_cidr
  subnet_cidr_block = var.subnet_cidr
}



## Note references to outputs of module vpc_proj2
module "web_proj2" {
  #  source            = "../modules/aws-web-server-instance"
  source            = "github.com/rpgd60/tfcourse-modules//web-modules/aws-web-server-instance"
  os                = var.server_os
  ec2_instance_name = "web-p2-${local.name_suffix}"
  ec2_instance_type = var.ec2_instance_type
  vpc_id            = module.vpc_proj2.vpc_id
  subnet_id         = module.vpc_proj2.subnet_id
  sec_group_ids     = [module.vpc_proj2.web_sec_group_id]
}
