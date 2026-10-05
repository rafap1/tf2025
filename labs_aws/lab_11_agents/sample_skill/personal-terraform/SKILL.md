---
name: personal-terraform
description: Rafa's personal Terraform/OpenTofu style - file layout, naming and conventions, captured as per-provider skeleton .tf files. Use whenever creating, editing or reviewing Terraform code, alongside terraform-skill (general best practices). On matters of style and layout, this skill takes precedence.
license: MIT
---

# Personal Terraform style

The skeleton files under `assets/` are the style guide. Match them rather than
inventing a layout.

## How to use

1. Use the information in this document, complemented with the skeleton for the provider in use:
   - AWS: `assets/aws/`
   - GCP: `assets/gcp/` 
   - Azure and other providers : not yet available - follow the AWS skeleton's structure and
     conventions, adapted to that provider.
2. Read this and every file in that skeleton before writing any Terraform.
3. New module or root config: copy the skeleton and fill it in. Keep the file
   split, ordering and naming as-is.
4. Existing code: match the skeleton's conventions in what you add or change.
   Don't restyle untouched code unless asked.

## Relationship to terraform-skill

- `terraform-skill` (Anton Babenko) covers general practice: module design,
  testing, CI, security, state.
- This skill covers personal style: file layout, naming, formatting and the
  default boilerplate.
- If they conflict on style, follow this skill. On correctness or security,
  raise the conflict with the user rather than silently picking one.

## Resource naming standards
- Most projects have variables for :
  - region, e.g. "eu-west-1" for AWS or equivalent for other providers
  - company, e.g. "lumon"
  - project, e.g. "mdr"  (in GCP deployments, "project" has a very specific meaning so we often do not use this variable)
  - department, e.g. "legal" 
  - environment, e.g. "dev", "pro"
- We use these variable values to build a standard `name_suffix` local variable that will be used for namingresources as they are created:

```
## AWS - locals.tf
  name_suffix = "${var.project}-${var.environment}"
 
## AWS - vpc.tf
resource "aws_security_group" "alb" {
  name = "alb-${local.name_suffix}"
(...)
}
```

- Naming for global resources like IAM roles. To avoid collisions when deploying in more than one region,  we create a special `name_suffix_with_region` local variable.  We use it to name global resources. 
```
## AWS - locals.tf
  name_suffix_with_region = "${var.project}-${var.environment}-${var.region}"

## AWS - iam.tf
resource "aws_iam_role" "ec2_instance" {
  name = "ec2-${local.name_suffix_with_region}"
(...)
}
```

## .gitignore files for Terraform
- Against the advice in the usual Terraform.gitignore file from GitHub, in principle we do not include in .gitignore `.tfvars` or `.tfvars.json` files.  The reason is that we never include any sensitive values in .tfvars files.
## Tag / Label standards
- If permitted by the provider, try to pack as many tags (AWS) and labels (GCP) in the provider.
-  AWS: default_tags - see example in aws/providers.tf .  Note that we include company name in the tag name, as in the example below:

```hcl
provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      "${var.company}:environment" = var.environment
      "${var.company}:project"     = var.project
      "${var.company}:cost-center" = var.cost_center   
      created_by                   = "terraform"
    }
  }
}
```
- GCP 

## Sharing information among different terraform stacks
- When possible favor using data sources over shared remote state.  
- Note that data sources are more useful in some providers (like AWS) than others

## 
