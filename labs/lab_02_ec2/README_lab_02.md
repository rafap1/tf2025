# Lab 2 - Terraform introduction

NOTE: You can view this markdown file rendered in Visual code with the following key combinations:

- Windows **Ctrl + Shift + V**
- Linux : **Ctrl + Shift + V**
- macOS:  **command  + shift +V**

### Introduction
- Main goals of this lab:

- Explore terraform code and the usual conventions on file names
- Practice again the terraform commands to deploy, explore and destroy infrastructure
### 1. Explore the terraform code and deploy the infrastructure
#### 1.1 Explore Code
We have the following files
    - "Standard" files - by convention we use this file names - NOT obligatory
        - providers.tf: terraform block and providers block (other conventions use a file name called `versions.tf` for this)
        - variables.tf: definition of variables
        - locals.tf : definition of local variables
        - data_sources.tf : definition of data sources
        - outputs.tf : definition of values we want to output
        - terraform.tfvars : file where we can assign values for variables defined in variables.tf
    - Application or deployment specific files 
        - ec2.tf : definition of VM resources
        - vpc_sg.tf : definition of VPC (network) stuff, including security group (sg)
        - Note: another convention is to define all these resources in a `main.tf`
#### 1.2 Deploy the infrastructure
- When operating terraform in local ("manual") mode we will usually run the following sequence
    - `terraform init` (done only the first time) - 
        - Review the output - compare the version of the AWS provider with the information from `providers.tf`
    - `terraform fmt` - formats code according to HashiCorp Style Guide
    - `terraform validate` - syntactic validation of code - catches basic errors
    - `terraform plan` - terraform compares the existing the contents of the `state file` (at this point none exists) with the contents of the `.tf` files and explains what it is going to do (it does not yet create or destroy anything).   Explore the output of this command carefully.  Can you list what terraform is planning to create?   
        - Pay particular attention to the lines below :`Terraform will perform the following actions:`
        - And to the line :  `Plan: 2 to add, 0 to change, 0 to destroy.`
        - What you are seeing is the "heart and soul" of Terraform.  We will talk at length about plan throughout this course.
    - `terraform apply` - Now it is time to actually do stuff.   You will see the same output as `terraform plan` and at the end you are asked to type "yes" to actually perform the actions.  Explore the output
#### 1.3. Connect to the AWS console and verify what Terraform has created
- In your browser connect to URL:  https://gkcourse.awsapps.com/start/#/
- Enter your assigned username: `studentXX` 
- Enter your password
- You may be asked to change your password.  Please do so and remember the password you created.
- You will see a welcome page `AWS Access Portal`.   Select your account by clicking on the "triangle" besides studentXX, and then on the `terraform-student` link.
- You will find yourself in an AWS console for your specific AWS Account.
- Now you need to move to the region where you created the infrastructure.   This is given by the variable `region`.  You can find it in file `terraform.tfvars`
- Then select the service EC2 (Elastic Compute Cloud) - you should see your VM / EC2 Instance.

### 2. Additional Exercises
- Explore impact of changes in the behavior of  `terraform plan` :
    - In file `terraform.tfvars` change the value of variable `cost_center`. 
        - Run `terraform plan` -- what changes?
        - Run `terraform apply` - observe the changes in the AWS Console
    - In file `terraform.tfvars` change the value of variable `project`. Run `terraform plan`
        - Run `terraform plan` -- what changes?  What is the difference with the previous change?  Why?
        - Run `terraform apply` - observe the changes in the AWS Console
- Explore assigning variables with different mechanisms (Env variables or in the CLI).  Examples
    - For example `terraform plan -var 'cost_center=foobar'`

### 3. Clean up - `terraform destroy`
- Now we are going to destroy the created infrastructure - so that you can practice this important phase of the infra lifecycle.  
    - It also  helps keep costs of the lab down and be environmentally friendly.
- Try the command `terraform plan -destroy`
    - This command tells terraform : "tell me what you would do if I asked you to destroy the infrastructure you manage"
    - Review the output - terraform plans to destroy the infrastructure it created previously
- Try the command `terraform destroy`
    - Terraform will again list what it intends to destroy, and will ask your permission 

- You can also try the command `terraform destroy -auto-approve` that will destroy the infrastructure without asking permission. If you have already destroyed the infra in the previous step, you can create it again and then destroy it again.
