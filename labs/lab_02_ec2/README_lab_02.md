Lab 2 - Terraform files.  Terraform and provider version

This lab creates the same basic AWS infra as Lab_01 : a security group and a virtual machine (EC2 instance, in AWS-speak)
The code in this lab almost the same code as in lab 1, but we place it in a set of .tf (and a new .tfvars) files:

### 1. Explore the terraform code
We have the following files
    - "Standard" files - by convention we use this file names - NOT obligatory
        - providers.tf: terraform block and providers block
        - variables.tf: definition of variables
        - locals.tf : definition of local variables
        - data_sources.tf : definition of data sources
        - outputs.tf : definition of values we want to output
        - terraform.tfvars : file where we can assign values for variables defined in variables.tf
    - Application or deployment specific files - these are specific to this deployment (we could also put them all in a file called main.tf)
        - ec2.tf : definition of VM resources
        - vpc_sg.tf : definition of VPC (network) stuff

### 2. Experiment with the terraform and provider versions:
#### 2.1 Terraform version
- When working on a project we want to specify the version of terraform we use, to protect ourselves against possible breaking changes.
- Using always "the latest" terraform may not be a good idea.  
    - Think of this as using a specific version of java or python in your development project
- Useful documentation: terraform tutorial at: https://developer.hashicorp.com/terraform/tutorials/configuration-language/versions
    - Suggestion: follow the tutorial by reading it.  try to apply some of these examples to your lab environment.  An example follows
- Using tfenv,  change the version of terraform to, say, 1.11.4 : `tfenv use 1.11.4`
```bash

% tfenv use 1.11.4
Switching default version to v1.11.4
Default version (when not overridden by .terraform-version or TFENV_TERRAFORM_VERSION) is now: 1.11.4
```

- Now try `terraform plan` - you may be getting an error related to : `required_version = "~> 1.12.0"` in providers.tf
    - this is because in our code we "pinned" the terraform version to 1.12.XX 
- Change the code in providers.tf to:  `required_version = "~> 1.11.0"`

#### 2.2 Provider Version
- Providers are plugins, essentially extensions to the terraform code to handle a specific API (in our case AWS provider for the AWS API)
- AWS and Terraform constanly release new versions of the AWS provider, and this may sometimes introduce features that break or modify existing infrastructure.
- Thus we want a way to "pin" the specific version of the provider.
    - Think of this as using a specific version of a java library or python module in your code (e.g. requirements.txt file for python)
- Suggestion: read the docs on this subject in : https://developer.hashicorp.com/terraform/tutorials/configuration-language/provider-versioning

