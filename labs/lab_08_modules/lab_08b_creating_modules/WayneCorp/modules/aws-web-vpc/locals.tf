locals {
    sg_name = "${var.vpc_name}-sg-${random_id.sg_suffix.id}"
}