
variable "dalist" {
  type    = list(string)
  default = ["we", "are", "the", "champions", "my", "friend"]
}
locals {
  dalist_upper_tuple      = [for s in var.dalist : upper(s)] ## Brackets around for statement => output is tuple
  dalist_upper_tuple_filt = [for s in var.dalist : upper(s) if s == "friend"]

  dalist_upper_obj      = { for s in var.dalist : s => upper(s) }                     ## Curly brackets around for statement => output is object
  dalist_upper_obj_filt = { for s in var.dalist : s => upper(s) if s == "champions" } ## Curly brackets around for statement => output is object

}


