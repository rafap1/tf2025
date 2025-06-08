This module creates a simple VPC with a public subnet and the main related components:

- VPC
- One Public subnet
- Internet GW
- Route table 
- Security Group

Input parameters  (see variables.tf)
- VPC Name - mandatory
- VPC CIDR - mandatory
- Subnet CIDR - mandatory
- Subnet Name - mandatory

- AWS AZ - optional

Output parameters (see outputs.tf)
- vpc_id
- subnet_id
- subnet_cidr
- subnet_az
- web_sec_group_id

The module's vpc functionality is kept very simple to emphasize the module structure and inputs/outputs 
An obvious improvement could be creating multiple public subnets within the VPC
(but for that we already have the official AWS VPC module :-)  )
