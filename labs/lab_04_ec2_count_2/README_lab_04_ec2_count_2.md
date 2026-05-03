# Lab 4 - EC2 using count - 2 

## Purpose of lab
- The main purpose of this lab is to explore an undesirable behavior of using "count".  
- In summary, `count` is very useful but sometimes it is better to use `for_each` seen later.

- We also explore a little trick to create multiple instances with names
  - Note : here it is also better to use `for_each` but this is just to practice local variables, lists and the function length()

## Preliminary
- Explore code - starting with ec2.tf
- Note the `count = local.ninstances` inside the definition of the aws_instance.
- Now explore the definition of the local variable ninstances in locals.tf . what is the type? -- where do we get its value
- Look at the definition of the variable `instance_names` in variables.tf

- we see that the number of instances created depends on the length of the list of names



## Main test

- create 4 instances
  - Note: the instance IDs below will be different in your case
- we can list the ids by using terraform console and the 'splat' as seen in the previous lab.
```
echo 'aws_instance.server[*].id' | terraform console
[
  "i-0d91fe62578dadb1b",       (dep1)
  "i-0859c8e995606a474",       <<<< this is the one we want to delete in the next step... (dep2)
  "i-0cecacac55c431c51",       (dep3)
  "i-0fc6511b60c5a9abc",       (dep4)
]
```
- Now remove "dep2" from the list  
(in default  or in terraform.tfvars)
instance_names = ["dep1", "dep2", "dep3", "dep4"]

- And do terraform apply - Let's see what instances we have....

echo aws_instance.server[*].id | terraform console
[
  "i-0d91fe62578dadb1b",
  "i-0859c8e995606a474",  <<< not deleted...    terraform has just deleted the last one (originaly dep4)
  "i-0cecacac55c431c51",
]

- What happened is that `count` went from 4 to 3 .. terraform deleted the latest, not the one we wanted.

- conclusion : in some cases it is better to use for_each. it gives you more control on the infra created.
- but...  count is still very useful and widely used.