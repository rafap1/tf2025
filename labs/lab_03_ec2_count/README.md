Things to test

## Info from state file
terraform state list
terraform state pull (similar to viewing state file)

## Interrogate state with terraform console
echo aws_instance.server | terraform console
what do you get?

Explore interrogating state - compare difference between two sets  ( [*] is referred to as "splat")
Note that aws_instance.server is now an array with num_instances elements

echo "length(aws_instance.server)" | terraform console


echo aws_instance.server[1] | terraform console
echo aws_instance.server[1].public_ip | terraform console

echo aws_instance.server[*] | terraform console
echo aws_instance.server[*].public_ip | terraform console

## More on terraform console
we can also interrogate the variables
echo var.num_instances | terraform console

## Output blocks

Take a look at the output blocks... what has changed vs lab02

## Change number of instances
Increment num_instances by one, perhaps by adding it to file terraform.tfvars
What happens

## Add a validation to the num_instances variable
for example >0 and <=4
Test it... is it enough with terraform validate?  or do you need to do terraform plan?





