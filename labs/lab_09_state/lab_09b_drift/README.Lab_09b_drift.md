# Lab 09b - Drift

- Note : this lab uses at the end 'terraform import' - There is a newer way to import with blocks as seen in Lab 09a 

This lab follows HashiCorp's tutorial "Manage Resource Drift" at
https://developer.hhicorp.com/terraform/tutorials/state/resource-drift

- This lab creates infrastructure (EC2 Instance with a securith group)
- We then generate drift: create (outside of Terraform, with AWS CLI) a second security group and apply it to the instance.
- Then it uses `terraform plan -refresh-only` to detect
Some changes to align with course environmant:

- region -> eu-south-2

- Command to generate ssh key pair  (you can keep the example.com email).  This command must be run in the same directory you have the terraform files

ssh-keygen -t rsa -C "your_email@example.com" -f ./key

- Commands to introduce drift :   add `--profile sso-student`   to all AWS Commands:

For example: 
```
export SG_ID=$(aws ec2 create-security-group --group-name "sg_web" --description "allow 8080" --output text --profile sso-student)

aws ec2 authorize-security-group-ingress --group-name "sg_web" --protocol tcp --port 8080 --cidr 0.0.0.0/0 --profile sso-student

aws ec2 modify-instance-attribute --instance-id $(terraform output -raw instance_id) --groups $SG_ID --profile sso-student
```


