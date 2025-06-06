# Lab 5 - Terraform Expressions - for expressions

## Purpose of the lab
- explore expressions, for, etc.
- explore using terraform console to test

## How to use these examples
- No need to run terraform init,  plan or apply
- Simply run "terraform console" - this automatically creates an empty tfstate file
- The variables and locals become available in the console


### Explore
- Explore the definitions in locals.tf and variables.tf
- try these or similar commands

```t
$ terraform console
> local.dalist_upper_tuple
[
  "WE",
  "ARE",
  "THE",
  "CHAMPIONS",
  "MY",
  "FRIEND",
]
> local.dalist_upper_obj
{
  "are" = "ARE"
  "champions" = "CHAMPIONS"
  "friend" = "FRIEND"
  "my" = "MY"
  "the" = "THE"
  "we" = "WE"
}
> local.dalist_upper_obj_filt
{
  "champions" = "CHAMPIONS"
}
```

For the more complex example with filters:

```t
$ terraform console
> var.users
tomap({
  "jose andres" = {
    "dept" = "Accounting"
    "is_admin" = false
  }
  "paco" = {
    "dept" = "Planning"
    "is_admin" = false
  }
  "rafa" = {
    "dept" = "IT"
    "is_admin" = true
  }
})

> local.regular_users
{
  "jose andres" = {
    "dept" = "Accounting"
    "is_admin" = false
  }
  "paco" = {
    "dept" = "Planning"
    "is_admin" = false
  }
}
```t
other queries within terraform console
```t
> local.regular_users["jose andres"]
{
  "dept" = "Accounting"
  "is_admin" = false
}
> local.regular_users["jose andres"]["dept"]
"Accounting"
```
Uncommenting the terraform.tfvars contents yields:
Note:  we need to exit terraform console and start it again

```t
$ terraform console
> var.users
tomap({
  "gian battista" = {
    "dept" = "Accounting"
    "is_admin" = false
  }
  "mauro" = {
    "dept" = "IT"
    "is_admin" = true
  }
  "valentina" = {
    "dept" = "Planning"
    "is_admin" = false
  }
})
> local.admin_users
{
  "mauro" = {
    "dept" = "IT"
    "is_admin" = true
  }
}
```
