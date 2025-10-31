# Lab 2 - Terraform files.  Terraform and provider version

NOTE: You can view this markdown file rendered in Visual code with the following key combinations:

	- Windows **Ctrl + Shift + V**
	- Linux : **Ctrl + Shift + V**
	- macOS:  **command  + shift +V**

### Introduction
- This lab creates the same basic AWS infra as Lab_01 : a security group and a virtual machine (EC2 instance, in AWS-speak)
- The code in this lab almost the same code as in lab 1, but we place it in a set of .tf (and a new .tfvars) files:

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
### 2. Experiment with the terraform and provider versions:
#### 2.1 Terraform version
- When working on a project we want to specify the version of terraform we use, to protect ourselves against possible breaking changes.
- Using always "the latest" terraform may not be a good idea.  
    - Think of this as using a specific version of java or python in your development project
- Useful documentation: terraform tutorial at: https://developer.hashicorp.com/terraform/tutorials/configuration-language/versions
    - Suggestion: follow the tutorial by reading it.  try to apply some of these examples to your lab environment.  An example follows
- (Note - only linux / Mac) Using tfenv,  change the version of terraform to, say, 1.12.2 : `tfenv use 1.12.2`
```bash

% tfenv use 1.12.2
Switching default version to v1.12.2
Default version (when not overridden by .terraform-version or TFENV_TERRAFORM_VERSION) is now: 1.12.2
```

- Now try `terraform plan` - you may be getting an error related to : `required_version = "1.12.2"` in providers.tf
    - this is because in our code we "pinned" the terraform version to 1.12.4 
- Change the code in providers.tf to:  `required_version = "~> 1.12.0"`
- Now try again `terraform init` -- you will be asked to repeat it with `-init` flag
#### 2.2 Provider Version - specifying version
- Providers are plugins, essentially extensions to the terraform code to handle a specific API (in our case AWS provider for the AWS API)
- AWS and Terraform constanly release new versions of the AWS provider, and this may sometimes introduce features that break or modify existing infrastructure.
- Thus we want a way to "pin" the specific version of the provider.
    - Think of this as using a specific version of a java library or python module in your code (e.g. requirements.txt file for python)
- Suggestion: read the docs on this subject in : https://developer.hashicorp.com/terraform/tutorials/configuration-language/provider-versioning

#### 2.3 Provider version - Dependency lock file
- Take a look at the file `.terraform.lock.hcl`
- Please read the documentation on the dependency lock file : https://developer.hashicorp.com/terraform/language/files/dependency-lock  
- We will discuss it further in the course, but here is a brief description:
    - In summary,  this dependency file is useful when your are allowing some "freedom" in the choice of Provider version (as in this lab where we specify `version = "~> 6.0.0"`).   Without this lock file, every time we run `terraform init` terraform would attempt to download and use the latest version of the provider, e.g. 6.0.1, 6.1.0, etc... This would lead to an uncontrolled and unpredictable environment.  The file `.terraform.lock.hcl` tells Terraform: "Even if there is a newer version of the provider, stick to the one mentioned in this file".   If you really really want to upgrade, then perform `terraform init -upgrade`


### 3. Additional Exercises
- Explore impact of changes in the behavior of  `terraform plan` :
    - In file `terraform.tfvars` change the value of variable `cost_center`. 
        - Run `terraform plan` -- what changes?
        - Run `terraform apply` - observe the changes in the GCP Console
    - In file `terraform.tfvars` change the value of variable `department`. Run `terraform plan`
        - Run `terraform plan` -- what changes?  What is the difference with the previous change?  Why?
        - Run `terraform apply` - observe the changes in the GCP Console
- Explore assigning variables with different mechanisms (Env variables or in the CLI).  Examples
    - For example `terraform plan -var 'cost_center=foobar'`

### 4. Clean up
- Now we are going to destroy the created infrastructure - so that you can practice this important phase of the infra lifecycle.  
    - It also  helps keep costs of the lab down and be environmentally friendly.
- Try the command `terraform plan -destroy`


