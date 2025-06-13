# Lab 09b - Import Block


## Purpose of this lab
- Explore the behavior of import state with two cases
    - Importing a single instance
    - Importing a group of instances created with for_each
    - Importing a security group

## How to perform the lab
### First Create Infrastructure
- First run again Lab_06_for_each again.   You should "terraform apply" and create the infrastructure.
- If you ran the lab earlier, please run `terraform destroy` and then `terraform apply` again.  We have made some changes to this lab.
- This will create following infra:

```
% terraform state list
aws_instance.example["app-01"]
aws_instance.example["app-02"]
aws_instance.example["web-01"]
aws_instance.example["web-02"]
aws_instance.example_1
aws_security_group.sec_web
```
### Get a list of the instance Name and Instance IDs
- We will use this list when we import the infrastructure
- Run the following commands in your machine : the first will list the security group and its id.  The second the vms and their id.   We are filtering for those that have "lab06" in the Name tag (instances) or name (sg)
- if for some reason you are using 'eu-west-1' as your region, change the REGION=xxxxxx below.
- for the security group we run:
```
REGION=eu-south-2
PROFILE=sso-student
aws ec2 describe-security-groups \
  --region $REGION \
  --profile $PROFILE \
  --filters "Name=group-name,Values=*lab06*" \
  --query 'SecurityGroups[].[GroupName, GroupId]' \
  --output table
```
- Result should be something like:
---------------------------------------------------
|             DescribeSecurityGroups              |
+------------------------+------------------------+
|  sec-web-mdr-dev-lab06 |  sg-094ed7810d9c09a32  | YOUR VALUE WILL BE DIFFERENT
+------------------------+------------------------+
```
REGION=eu-south-2
PROFILE=sso-student
aws ec2 describe-instances \
  --region $REGION \
  --profile $PROFILE \
  --filters "Name=tag:Name,Values=*lab06*" \
  --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value | [0], InstanceId]' \
  --output table
```
- You should get something like the following.  Copy to some safe place.
-------------------------------------------------
|               DescribeInstances               |
+-----------------------+-----------------------+
|  web-02-mdr-dev-lab06 |  i-sssssssssssss4233  | YOUR VALUE WILL BE DIFFERENT
|  web-01-mdr-dev-lab06 |  i-sdfdfdfdfc1a4c7e8  |
|  app-01-mdr-dev-lab06 |  i-sdfsdfe10616277c2  |
|  test-mdr-dev-lab06-1 |  i-sdfsdfsd7012fc4aa  |
|  app-02-mdr-dev-lab06 |  i-ssdfb6c1b664cc908  |
+-----------------------+-----------------------+
### Then get your terraform (in lab06) to forget infrastructure
- Now IN THE SAME lab06 DIRECTORY delete the .terraform directory and the *tfstate* files
- You have essentially "forgotten" the infra we just created. 
- The infra is in AWS but not in Terraform
- Strictly speaking you do not need to do this "forgetting" in the lab06 directory since we will be importing in another directory,  but it is a more realistic scenario 

### Move to Lab09 directory - Import infrastructure
- Now move to lab_09a  - You will see a similar set of files, but instead of ec2.tf and vpc.tf files you have a single file infra_to_import.tf.  We also removed outputs.tf (you can add it later if you wish)
- All the code in this file should be commented. 
- We are going to import infra in 3 steps:
    - Import the security group, since it is used by the other two
    - Import the single instance (you can skip this)
    - Import group of instances created by for_each

### Let's start with a terraform init - validate - plan - apply
- Nothing should be created since we do not have "resource" in our configuration
- For good measure, try `terraform state list`. You should get the data sources.
```
data.aws_ami.ubuntu_24_04_x86
data.aws_subnets.def_vpc_subnets
data.aws_vpc.def_vpc
```
## 1. Import the security group
- Uncomment the code between the "start STEP-1 and end STEP-1"
- in the import block replace "sg-xxxxxxxxxxxx" with the actual id of your security group from the CLI command above
- The resource.aws_security_group  block is the configuration for our security group
- the import block below tells terraform to import the security group `sg-xxxxxxxxxxxxxxx` and associate it with the resource `aws_security_group.sec_web`.   Remember, that kind of mapping  is *exactly* what the state file does.
```
import {
  to = aws_security_group.sec_web
  id = "sg-xxxxxxxxxxxxxxx"  ## your security group id
}
```
- perform terraform plan: we are told: `Plan: 1 to import, 0 to add, 0 to change, 0 to destroy.`
- perform terraform apply - terraform imports the security group
- now do `terraform state list`  you get the data sources and the security group
```
data.aws_ami.ubuntu_24_04_x86
data.aws_subnets.def_vpc_subnets
data.aws_vpc.def_vpc
aws_security_group.sec_web
```

### 2. Import the individual instance 
- Uncomment the code between the "start STEP-2" and "end STEP-2"
- In the import block change the id ("i-xxxxxx") to the one from machine 'test-mdr-dev-lab06-1' (from the aws cli command above)
- Perform `terraform plan`, `terraform apply`
- New state list - includes: aws_instance.example_1
```
data.aws_ami.ubuntu_24_04_x86
data.aws_subnets.def_vpc_subnets
data.aws_vpc.def_vpc
aws_instance.example_1
aws_security_group.sec_web
```

### 3. Import the four instances created with for_each
- Uncomment the code between the "start STEP-3" and "end STEP-3"
- In each of the import blocks change "i-xxxxxx" with the instance ID of the corresponding instance (web-01, etc.)
- IMPORTANT point: 
  - we created these 4 instances in lab_06 with a dynamic "for_each" construct
    - Of course in the real world the instances will not have been created with terraform. We will have to "reverse-engineer" the structure.  In this lab we assume we did that and we use the same for_each to define the resources.
  - For the import blocks, we can also use a for_each construct
    - We define a local variable that contains the instance IDs we retrieved with the aws cli command and we loop through it with a for_each.
    - You have to substitute the "i-xxxxx" etc for the specific IDs of your instances
```
locals {
  instance_mappings = {
    "web-01" = "i-xxxxx"
    "web-02" = "i-yyyyy"
    "app-01" = "i-zzzzz"
    "app-02" = "i-zzzzz"
  }
}

# Single import block with for_each
import {
  for_each = local.instance_mappings
  
  to = aws_instance.example[each.key]
  id = each.value
}
```

- Run terraform plan and terraform apply
- Updated state list - now includes the 4 instances 
```
data.aws_ami.ubuntu_24_04_x86
data.aws_subnets.def_vpc_subnets
data.aws_vpc.def_vpc
aws_instance.example["app-01"]
aws_instance.example["app-02"]
aws_instance.example["web-01"]
aws_instance.example["web-02"]
aws_instance.example_1
aws_security_group.sec_web
```

## Test the outputs
- copy the outputs.tf file from lab 6 to lab 9a
- run terraform apply again - you should see the outputs

## You can remove the import blocks
- Once the infrastructure is safely in the state file you can remove the import block
## Clean up
Please run terraform destroy to remove the infrastructure