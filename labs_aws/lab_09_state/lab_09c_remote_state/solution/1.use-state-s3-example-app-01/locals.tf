## Locals

locals {
  # account_id = data.aws_caller_identity.current.account_id
  # Below used for troubleshooting
  # vpc_info   = data.aws_vpc.def_vpc
  # subnet_info = data.aws_subnets.def_vpc_subnets
}

locals {

  name_suffix = "${var.project}-${var.environment}-${var.lab_number}"

}