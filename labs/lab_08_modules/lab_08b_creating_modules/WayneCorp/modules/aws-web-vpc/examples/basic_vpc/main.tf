module "basic_vpc" {
  source            = "../../../../modules/aws-web-vpc"
  vpc_cidr_block    = "10.99.0.0/16"
  subnet_cidr_block = "10.99.2.0/24"
  vpc_name          = "vpc_module_example1"
  aws_az            = "eu-west-1b"
  subnet_name       = "vpc_module_example1"
}

module "basic_vpc2" {
  source            = "../../../aws-web-vpc"
  count = 2
  vpc_cidr_block    = "10.88.0.0/16"
  subnet_cidr_block = "10.88.2.0/24"
  vpc_name          = "vpc_module_example2-${count.index}"
  aws_az            = "eu-west-1c"
  subnet_name       = "vpc_module_example2-${count.index}"
}