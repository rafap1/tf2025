## Lab 07b - Creating VMs in vpc / subnets located with data sources

## Important reminders

- This lab (07b) must be performed after 07a
- You do `terraform apply` first in 07a and then in 07b
- When you are done, you do `terraform destroy` first in 07b and then in 07a


## Warning 

- This lab assumes some knowledge of AWS VPC (Networking) such as : vpc, subnet, route table, availability zone

## Purpose of the lab
- This lab is also intented as a review of Module 4 (Terraform Language) in the course 
- In lab (07a) we create only VPC infrastructure  (e.g. subnets).  In a way, we assume we are an infrastructure team of sorts.
- Then in this lab (07b) we assume we are an application team that will create Virtual Machines in these subnets.  We will obtain the subnet IDs using data sources.

- We cover :
  - data sources for Ubuntu AMI,  VPC Id and the subnets created in subnet

## What do we create
- A number of VMs (EC2 Instances) distributed among the private subnets created in lab 07a
- If (from lab 07a) we have 3 subnets and here we want to create 5 instances (var.num_vms), the vms will be assigned to subnets as follows: 
  - Instance 0 -> subnet 0
  - Instance 1 -> subnet 1
  - Instance 2 -> subnet 2
  - Instance 3 -> subnet 0  <- start again thanks to the "element" function of terraform
  - Instance 4 -> subnet 1 

- Interesting Note: in this lab 07b we have commented out the `az_count` variable.  We do so because we get this value implicitly from the data source `data.aws_subnets.private_subnets`.  To create the VMs we just need the subnets and from the subnets we get implicitly the AZ.  This is a specific thing of AWS networking (you chose an AZ by choosing the subnet)

## Things to explore and test
- Review in the docs the difference between data sources:
  - `aws_subnet`  : https://registry.terraform.io/providers/hashicorp/aws/5.99.1/docs/data-sources/subnet
  - `aws_subnets` : https://registry.terraform.io/providers/hashicorp/aws/5.99.1/docs/data-sources/subnets
  - In this lab we use `aws_subnets` as the main tool to gather the private subnet IDs.
  - We also use `aws_subnet` to practice `for_each` and  build an auxiliary map that we use in output 
- Review the VMs created and their networking characteristics. They should not have a public IP and they should be in one of the three private subnets.
- Review the outputs, in particular `vm_id_subnet_id_cidr` and try to understand how it was built (not trivial).   
- Try to create your own `for` examples for outputs.
- Try some output with splat [*]
- Try commands with the terraform console as in 07a.

## Bonus assignment
- Look again at the aws_subnets definition (link above).  Specifically check the example provided (below from version 5.99.1 of provider).   You see that they create a set of instances (VMS) using "for_each".  In our lab we use "count".
- Your assigment 1:  create one instance in each subnet using for_each
- Your assignment 2 (more difficult?) : create num_vm instances distributed into az)count subnets.  You may notice that for taht case it may be simpler to use count and the "element" function.
```
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Tier = "Private"
  }
}

resource "aws_instance" "app" {
  for_each      = toset(data.aws_subnets.private.ids)
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = each.value
}
```