

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
  test2 = [for clave, valor in local.instance_info : "Maps ${clave} to ${upper(valor)}"]


}
