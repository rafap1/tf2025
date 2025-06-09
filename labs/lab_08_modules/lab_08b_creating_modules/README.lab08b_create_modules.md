## Lab 08b Terraform Modules - Create Modules

Example creating simple but complete modules
- vpc
- server instances

## Module Goals
The goal of the module labs is to understand the relationships between the root module and the called modules, as well as the structure of a deployment with modules
- Where the modules are defined
    - What "input" parameters they expect 
    - What "outputs" they produce
- How they are called
    - How to pass parameters - required vs optional parameters
    - How to retrieve outputs from "inner" modules

Important note: 
- The modules we create (server, vpc) are probably too "thin" (thin wrapper around vpc and ec2 instance) but are meant to serve as illustration

## What we have
- A project structure like the one below
- A modules directory where we define terraform code to be reused
- One or more project directories (project1, project2) that use the modules

## What to test
- Build project1
    - cd to /WayneCorp/project1
    - perform terraform init.   
        - See that .terraform directory now includes a `modules` directory with a json file that points to the local directories (note we do not "copy" the module code to `project1/.terraform/modules`)
    - terraform validate / plan / apply
    - verify state file with terraform state list
        - You can see that project one has "called" the VPC module once with name "my_web_vpc"
        - It has also "called" the instance module twice, with names "web1" and "web2"
        - in total we have created 15 resources

```
project1 % terraform state list
module.my_web_vpc.aws_internet_gateway.web_server_igw
module.my_web_vpc.aws_route_table.web_server_rt
module.my_web_vpc.aws_route_table_association.web_server_rt_association
module.my_web_vpc.aws_security_group.web_server_sg_name
module.my_web_vpc.aws_subnet.web_server_subnet
module.my_web_vpc.aws_vpc.web_server_vpc
module.my_web_vpc.random_id.sg_suffix
module.web1.data.aws_ami.amazon_linux
module.web1.data.aws_ami.amazon_linux2_kernel_5
module.web1.data.aws_ami.ubuntu_22_04
module.web1.aws_instance.web_server_instance
module.web2.data.aws_ami.amazon_linux
module.web2.data.aws_ami.amazon_linux2_kernel_5
module.web2.data.aws_ami.ubuntu_22_04
module.web2.aws_instance.web_server_instance
```
- Verify infra created in AWS

- Build project2  - perform the same cases.

- Modify the Modules 
    - For example you could uncomment the 2nd tag in the vpc definition in the file /WayneCorp/modules/aws-web-vpc/main.tf

```
resource "aws_vpc" "web_server_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
    # Uncomment as test during lab execution
    module_name = "aws-web-vpc"
  }
}
```

- perform terraform plan in project1 or project2 - verify that it will apply the new tag





