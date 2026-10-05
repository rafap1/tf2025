# Lab 01 - Getting started

NOTE: You can view this markdown file rendered in Visual code with the following key combinations:

- Windows **Ctrl + Shift + V**
- Linux : **Ctrl + Shift + V**
- macOS:  **command  + shift +V**

### Introduction
- This lab is intended mainly as a demo and as a way to verify the student software installation
- The instructor will perform this lab with you
### 1. Login to AWS to obtain credentials for Terraform
- First login to the console to make sure you are using your own password.  Connect to https://gkcourse.awsapps.com/start
    - IMPORTANT : here you use `studentXX` - your own student ID and password. If this is the first time you login, use the password provided by the instructor. Otherwise use the password you created.

- Verify you have the aws cli installed : `aws --version` 
- Run the command `aws sso login --profile sso-student`
    - This should launch your browser with a login page.  IMPORTANT : here you use `studentXX` - your own student ID and password.
- Verify that you have credentials to access AWS (terraform will use the same credentials), running the command `aws sts get-caller-identity --profile sso-student`
```
% aws sts get-caller-identity --profile sso-student
Account: '761528455679'
Arn: arn:aws:sts::761528455679:assumed-role/AWSReservedSSO_terraform-student_9a3c52ca7b812c98/student00
UserId: AROA3CTVCCH7WPFMEONCU:student00
```
### 1. Explore the terraform code and deploy the infrastructure
#### 1.1 Quick exploration of the Terraform code.
- Unlike in other labs, here we put all the terraform configuration in a single file `main.tf`
- Do not worry about the details - we will cover them later in the course.
#### 1.2 Deploy the infrastructure
- Verify that you have terraform installed: `terraform version`
- When operating terraform in local ("manual") mode we will usually run the following sequence
    - `terraform init` (done only the first time) - 
        - Review the output - compare the version of the AWS provider with the information from `providers.tf`
    - `terraform fmt` - formats code according to HashiCorp Style Guide
    - `terraform validate` - syntactic validation of code - catches basic errors
    - `terraform plan` - terraform compares the existing the contents of the `state file` (at this point none exists) with the contents of the `.tf` files and explains what it is going to do (it does not yet create or destroy anything).   
        - What you are seeing is the "heart and soul" of Terraform.  We will talk at length about plan throughout this course.
    - `terraform apply` - Now it is time to actually do stuff.   You will see the same output as `terraform plan` and at the end you are asked to type "yes" to actually perform the actions.  
#### 1.3. Connect to the AWS console and verify what Terraform has created
- In your browser connect to URL:  https://gkcourse.awsapps.com/start/#/
- Enter your assigned username: `studentXX` 
- Enter your individual password
- You will see a welcome page `AWS Access Portal`.   Select your account by clicking on the "triangle" besides studentXX, and then on the `terraform-student` link.
- You will find yourself in an AWS console for your specific AWS Account.
- Now you need to move to the region where you created the infrastructure (by default eu-south-2).   This is given by the variable `region`.  You can find it in file `terraform.tfvars`
- Then select the service EC2 (Elastic Compute Cloud) - you should see your VM / EC2 Instance.

### 3. Clean up - `terraform destroy`
- Now we are going to destroy the created infrastructure - so that you can practice this important phase of the infra lifecycle.  
    - It also  helps keep costs of the lab down and be environmentally friendly.
- Try the command `terraform plan -destroy`
    - This command tells terraform : "tell me what you would do if I asked you to destroy the infrastructure you manage"
    - Review the output - terraform plans to destroy the infrastructure it created previously
- Try the command `terraform destroy`
    - Terraform will again list what it intends to destroy, and will ask your permission 

- You can also try the command `terraform destroy -auto-approve` that will destroy the infrastructure without asking permission. If you have already destroyed the infra in the previous step, you can create it again and then destroy it again.
