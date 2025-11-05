# Lab 3 - EC2 using count

aws sso login --profile sso-student

## Purpose of lab
- Explore creating multiple resources with 'count'
- Explore further the state
- Play with output blocks

## Preliminary
- Explore code - starting with ec2.tf
- Note the `count = var.num_instances` inside the definition of the aws_instance.
- Note also how we give a name to the tag using local variable and `count.index`



## Deploy and explore created infrastructure in AWS console
- Deploy infra (init, validate, plan, apply)
- login to AWS console (GUI) with your dedicated user student-tX-YY
    -  URL: https://gkcourse.awsapps.com/start/
- Ensure you are in the region specified in variable "region" (e.g. eu-west-1)
- Search for the "EC2" service in the top left search bar.  
- In the EC2 service, left menu, click on "instances".  You should see 3 instances (VMs)
    - Look for the tags. Select one instance and look at the "Tags" tab.  

## Explore state
terraform state list
```
data.aws_ami.ubuntu_24_04_x86
data.aws_caller_identity.current
data.aws_subnets.def_vpc_subnets
data.aws_vpc.def_vpc
aws_instance.server[0]
aws_instance.server[1]
aws_instance.server[2]
aws_security_group.sec_web
```
- Note the 3 aws_instance resources indexed from 0 - 2 (count=0, count=1, count=2)
- Try exploring the state of one of the instances created.  Single quotes are important!

terraform state show 'aws_instance.server[1]'

(note single quotes)

- You will get a lot of output about the second instance [1]
- With `terraform state show` we cannot get individual parameters such as the ami of instance [1]

```
terraform state show 'aws_instance.server[1].ami'

Error parsing instance address: aws_instance.server[1].ami

This command requires that the address references one specific instance.
To view the available instances, use "terraform state list". Please modify
the address to reference a specific instance.
```
- to get more info we can use `terraform console`

## Using Terraform console
- Try the following command to extract specific info (ami) from a given instance [1]
```
echo 'aws_instance.server[1].ami' | terraform console

"ami-0682c282a19c84de9"
```
- Explore interrogating state - compare difference between two sets  ( [*] is referred to as "splat")
- Note that aws_instance.server is now an array with `num_instances` elements

echo "length(aws_instance.server)" | terraform console


echo 'aws_instance.server[1]'| terraform console
(lots of output)
echo 'aws_instance.server[1].public_ip' | terraform console

echo 'aws_instance.server[*].public_ip' | terraform console
- when you use the splat you get an 'array' of results
[
  "18.201.xxx.177",
  "34.244.yyy.67",
  "34.241.zzz.232",
]

## More on terraform console
- we can also interrogate the variables
echo var.num_instances | terraform console

## Output blocks

Take a look at the output blocks... what has changed vs lab02
Explore the definition of output `public_ip` and the command `terraform output public_ip`
## Change number of instances
- Increment `num_instances by one`, perhaps by adding the variable with value 4 to file terraform.tfvars
- What happens?
- Now decrement by one - check `terraform plan`.  which machine will be destroyed?

## Add a validation to the num_instances variable
- for example >0 and <=4
- Test it for example changing the variable number to 0 or to 5
- Can you catch the errors `terraform validate`?  or do you need to do `terraform plan`?

## Destroy infra
explore `terraform plan -destroy`  (speculative command - we are asking Terraform: what would you do if I asked to destroy everything?)
then `terraform destroy -auto-approve`


