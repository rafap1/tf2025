# Lab 07 - VPCs using count - Review of content from chapter 4 - Terraform Language

## Important reminder
- Please remember to perform `terraform destroy` at the end of this lab.  Some resources are expensive (e.g. NAT GW)
    - NOTE: If you do also lab 07b,  you will have to `terraform destroy` lab 07b first.  You cannot destroy an AWS subnet if there is an EC2 instance (VM) associated with the subnet.

## Warning 
- This lab assumes some knowledge of AWS VPC (Networking) such as : vpc, subnet, route table, availability zone

## Purpose of the lab
- This lab is intented as a review of Module 4 (Terraform Language) in the course 
- We also try to present a slightly larger example creating 30+ resources
- In this lab (07a) we create only VPC infrastructure  (e.g. subnets).  In a way, we assume we are an infrastructure team of sorts.
- Then in the next lab (07b) we assume we are an application team that will create Virtual Machines in these subnets.  We will obtain the subnet IDs using data sources.

- We cover :
    - variables with validation and assignment in terraform.tfvars
    - local variables
    - conditional creation of resources (nat gateway), depending on boolean variable var.create_nat_gateway 
    - some functions: `cidr` (to generate subnet IP ranges), `can`, `cidrnetmask` and `endswith` to verify that VPC CIDR (IP range) is correct.
    - use of `for` in the outputs.  Related to this, for comparison we write the db_subnet info in two ways:
        - with a splat [*]
        - with a `for` - the `for` simplifies the construction of richer output or associations. 

## What do we create
- A VPC with a specfic CIDR (subnet) - the cidr block is obtained from variable : vpc_cidr. Note the functions in the validation
- Three sets of subnets :  public,  private and database,   representing a typical 3-tier scenario
    - For each tier (public, private, db) we create one subnet by availability zone driven by the variable az_count.
    - note the use of the `cidr` function to carve the IP ranges for each subnet
- Subnets created - assume VPC CIDR is 10.1.0.0/16 and we are using 3 Availability Zones (az_count=3).  In each AZ we create 3 subnets (one public, one private, one database).  So we end up with:
```
public_subnet_cidr = [
  "10.1.1.0/24",         <------ AZ 1
  "10.1.2.0/24",         <------ AZ 2
  "10.1.3.0/24",         <------ AZ 3  (If you set az_count = 2, this will not be created)
]
private_subnet_cidr = [
  "10.1.11.0/24",        <------ AZ 1
  "10.1.12.0/24",        <------ AZ 2
  "10.1.13.0/24",        <------ AZ 3  (If you set az_count = 2, this will not be created)
]
db_subnet_cidr_with = [
  "10.1.31.0/24",        <------ AZ 1
  "10.1.32.0/24",        <------ AZ 2
  "10.1.33.0/24",        <------ AZ 3  (If you set az_count = 2, this will not be created)
]
```
-  Note also that we obtain the AZs using yet another data source.  
    -  If we are working in region eu-south-2 this data source will query AWS and obtain the 'available' AZs.  Most of the time all 3 AZs will be available.
- We also create a NAT GW and routing tables for the subnets.  If you do not have much AWS knowledge you can safely ignore these and focus on the structure of the terraform code.

```
data "aws_availability_zones" "available" {
  state = "available"
}
```

Then when we create an AZ 

## Things to explore and test
- Check out the conditional creation of a nat gateway and its corresponding eip (NAT GW needs a public IP to do its NAT work)
    - change (e.g. in tfvars file)  the variable `create_nat_gw` from false to true.  Before doing so, explore the code and try to find what will change
        - After changing the variable, perform a terraform plan. confirm your understanding of what changes.
        - Then terraform apply.
    - repeat the exercise setting `create_nat_gw` to false again.  
- Change the number of AZs also in terraform.tfvars.   Try first 'wrong' values like 0 and 4.  Then 1 or 3.
    - compare with 
- Explore the outputs - try to play with `for` commands using as an example `db_subnet_cidr`
    - You need to do `terraform apply` to test your modifiaction.
    - For a more interactive experience, you can also execute these commands in terraform console. Example terraform console command below. Note that we "echo" the commands to terraform console. We do this because simply running `terraform console` locks the state file and we would prevent other people from performing plan and apply.

```
# Run below in linux/mac 
echo '[for s in aws_subnet.db_subnet : "CIDR ${s.cidr_block} in AZ: ${s.availability_zone}"]' | terraform console
[
  "CIDR 10.1.31.0/24 in AZ: eu-south-2a",
  "CIDR 10.1.32.0/24 in AZ: eu-south-2b",
  "CIDR 10.1.33.0/24 in AZ: eu-south-2c",
]

## Command in PowerShell:
echo "[for s in aws_subnet.db_subnet : `"CIDR ${s.cidr_block} in AZ: ${s.availability_zone}`"]" | terraform console
```
- Play with the `cidrnet` and similar functions and terraform console. You have examples int he hashicorp config. Example below.  YOU DO NOT NEED AN AWS ACCOUNT FOR THIS. You can run the command below in any directory without terraform init, etc.
```
echo 'cidrnetmask("10.1.1.0/24")' | terraform console
"255.255.255.0"
echo 'cidrnetmask("10.1.1.0/22")' | terraform console
"255.255.252.0"
```

- You could also play with other functions.  Here's a link to the docs: https://developer.hashicorp.com/terraform/language/functions