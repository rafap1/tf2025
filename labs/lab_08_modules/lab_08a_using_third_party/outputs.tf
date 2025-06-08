output "cual_es_el_id_de_vpc_one" {
  value = module.vpc_one.vpc_id
}

## this value comes from the output of the modul
output "cidr_de_vpc_one" {
  value = module.vpc_one.vpc_cidr_block
}

## this value comes from the output of the module
output "cidr_de_subredes_publicas" {
  value = module.vpc_one.public_subnets_cidr_blocks
}


output "ip_publica_de_server_pub" {
  value = aws_instance.server_pub.public_ip
}

output "ips_privadas_de_server_priv" {
  value = aws_instance.server_priv[*].private_ip
}







