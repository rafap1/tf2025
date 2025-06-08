locals {
  name_suffix = "${var.project}-${var.environment}-${var.lab_number}"
}


## Here we create an object variable with the same content we used explicitly above
## Note last item using spaces
locals {
  instance_info = {
    dep1           = "t3.nano"
    dep2           = "t3.micro"
    dep3           = "t3.micro"
    "department 4" = "t3.nano"
  }
}

locals {
  test1 = { for key, val in local.instance_info : upper(key) => upper(val) }
  test2 = [for clave, valor in local.instance_info : "Maps ${clave} to ${valor}"]
  test3 = [for k, pepe in aws_instance.example : "${k}-${pepe.public_ip}"]
  test4 = { for k, instance in aws_instance.example : instance.public_dns => instance.public_ip }

  test5 = { for k, instance in aws_instance.example : instance.id => { (instance.public_dns) = instance.public_ip } }
  test6 = [for k, instance in aws_instance.example : instance.public_dns]
  test7 = zipmap(local.test3, local.test6)

  region_ilustrada = "Mi region es ${var.region}"
}
