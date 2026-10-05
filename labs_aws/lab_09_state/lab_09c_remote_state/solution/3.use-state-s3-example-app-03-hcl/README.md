Testing S3 State

Here the S3-related configuration in the provider block is almost empty and we provide the common parameters (once) from a common file when running `terraform init` in this directory. 

Tip: save the actual init command in the README.md or more generally parametrize it in a higher level orchestration tool

Note: backend.hcl is common and kept in a common parent directory

```
$ ls 
dependencies.tf  main.tf  outputs.tf  providers.tf  README.md  terraform.tfvars  variables.tf


$ cat ../backend.hcl 
# backend.hcl
bucket         = "acme02-terraform-state-975030449833-dev"           
dynamodb_table = "acme02-terraform-state-locks-dev"  
region         = "eu-south-2"
encrypt        = true
profile        = "sso-student"
```
Running terraform init
```
$ terraform init --backend=true --backend-config=../backend.hcl

```

Verifying we now have 3 keys under the state bucket:
```
$ aws s3 ls acme02-terraform-state-YOURACCOUNT-dev --recursive --profile cta
2023-03-26 13:00:36      14441 acme02/example-01/terraform.tfstate
2023-03-26 13:06:45      14446 acme02/example-02/terraform.tfstate
2023-03-26 13:21:05      14469 acme02/example-03/terraform.tfstate

Verifying locks

aws dynamodb scan --table-name terraform-course-state-locks --profile cta